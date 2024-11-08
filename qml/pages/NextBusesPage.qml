import QtLocation 5.3
import QtQuick 2.5
import QtPositioning 5.2
import Sailfish.Silica 1.0

import org.blogreen 1.0

Page {
    id: page

    property variant teredata: []
    property int routeId: 0
    property int now: Date.now() / 1000
    property bool mapViewportNeedUpdate: true

    allowedOrientations: Orientation.All

    Timer {
        running: true
        interval: 5000
        repeat: true
        onTriggered: {
            page.now = Date.now() / 1000

            if (listView.model.get(0) && listView.model.get(0).endTimestamp < page.now) {
                listView.model.remove(0)
            }
        }
    }

    function firstTimestamp(model) {
        var ts = null

        for (var i in model.stopTimes) {
            if (ts == null || ts > model.stopTimes[i].arrivalTimestamp) {
                ts = model.stopTimes[i].arrivalTimestamp;

                origin.coordinate = QtPositioning.coordinate(model.stopTimes[i].stopInfo.position.lat, model.stopTimes[i].stopInfo.position.lng)
            }
        }

        return ts
    }
    function lastTimestamp(model) {
        var ts = null
        for (var i in model.stopTimes) {
            if (ts == null || ts < model.stopTimes[i].arrivalTimestamp) {

                ts = model.stopTimes[i].arrivalTimestamp;

                destination.coordinate = QtPositioning.coordinate(model.stopTimes[i].stopInfo.position.lat, model.stopTimes[i].stopInfo.position.lng)
            }
        }

        return ts
    }

    Component.onCompleted: {
        teredata.forEach(function(itm) {
            console.log(itm.name)
            itm.startTimestamp = firstTimestamp(itm)
            itm.endTimestamp = lastTimestamp(itm)
            console.log("endTimestamp: " + itm.endTimestamp)
            console.log("endTime: " + itm.endTime)
            listView.model.append(itm)
        })
    }

    SilicaListView {
        id: listView

        x: 0
        y: 0
        width: page.isLandscape ? parent.width / 2 : parent.width
        height: page.isLandscape ? parent.height : parent.height / 2

        header: PageHeader {
            title: qsTr("Next Buses")
        }

        model: ListModel {
        }

        delegate: ListItem {
            id: delegate

            width: ListView.view.width
            height: Theme.itemSizeMedium
            contentHeight: height

            onClicked: {
                var data = []

                console.info(JSON.stringify(model.stopTimes))

                pageStack.push(Qt.resolvedUrl("StopsPage.qml"), { teredata: model.stopTimes, routeId: page.routeId })
            }

            Column {
              anchors.verticalCenter: parent.verticalCenter
              x: Theme.horizontalPageMargin

              Label {
                id: title
                text: name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                //font.capitalization: Font.Capitalize
              }
              Row {
                id: details
                spacing: Theme.paddingMedium

                Label {
                  text: model.startTime
                  font.pixelSize: Theme.fontSizeSmall
                  color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
                Label {
                  text: model.endTime
                  font.pixelSize: Theme.fontSizeSmall
                  color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
              }
              Item {
                  width: 1
                  height: (delegate.height - title.height - details.height) / 4
              }
              Rectangle {
                height: (delegate.height - title.height - details.height) / 3
                width: (delegate.width - 2 * Theme.horizontalPageMargin) * ((page.now - model.startTimestamp) / (model.endTimestamp - model.startTimestamp))
                color: Theme.highlightBackgroundColor
              }
            }
        }

        ViewPlaceholder {
          enabled: listView.count == 0
          text: qsTr("End of service")
          hintText: qsTr("No bus found")
        }

        VerticalScrollDecorator {}
    }

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map

        x: page.isLandscape ? parent.width / 2 : 0
        y: page.isLandscape ? 0 : parent.height / 2
        width: page.isLandscape ? parent.width / 2 : parent.width
        height: page.isLandscape ? parent.height : parent.height / 2

        plugin: mapPlugin

        zoomLevel: 11

        center: QtPositioning.coordinate(-17.6483, -149.4923)

        MouseArea {
            anchors.fill: parent

            onPressed: {
                // Prevent the page from popping while allowing to move the map.
                // (most of the time)
            }
        }

        MapItemView {
            id: mapItemView

            model: BusPositionModel {
                id: currentPos
                lineId: page.routeId

                onRefreshed: {
                    if (!page.mapViewportNeedUpdate) {
                        return
                    }

                    var latitudes = [origin.coordinate.latitude, destination.coordinate.latitude]
                    var longitudes = [origin.coordinate.longitude, destination.coordinate.longitude]

                    for (var i = 0; i < mapItemView.model.count; i++) {
                        latitudes.push(mapItemView.model.get(i).lat)
                        longitudes.push(mapItemView.model.get(i).lng)
                    }

                    var tl = QtPositioning.coordinate(Math.max.apply(null, latitudes), Math.min.apply(null, longitudes))
                    var br = QtPositioning.coordinate(Math.min.apply(null, latitudes), Math.max.apply(null, longitudes))

                    map.fitViewportToGeoShape(QtPositioning.rectangle(tl, br))

                    page.mapViewportNeedUpdate = false
                }
            }

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.lat, model.lng)

                anchorPoint.x: marker.width * 0.5
                anchorPoint.y: marker.height

                sourceItem: Column {
                    id: marker
                    Text {
                        text: model.bus_id
                        font.pixelSize: Theme.fontSizeTiny
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Image {
                        id: image
                        source: "qrc:///images/marker-red.png"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        MapQuickItem {
            id: origin

            anchorPoint.x: origin.width * 0.5
            anchorPoint.y: origin.height

            sourceItem: Column {
                Text {
                    text: qsTr("Origin")
                    font.pixelSize: Theme.fontSizeTiny
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Image {
                    source: "qrc:///images/marker-blue.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        MapQuickItem {
            id: destination

            anchorPoint.x: destination.width * 0.5
            anchorPoint.y: destination.height

            sourceItem: Column {
                Text {
                    text: qsTr("Destination")
                    font.pixelSize: Theme.fontSizeTiny
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Image {
                    source: "qrc:///images/marker-green.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Timer {
        running: true
        interval: 5000
        repeat: true

        onTriggered: currentPos.refresh()
    }
}
