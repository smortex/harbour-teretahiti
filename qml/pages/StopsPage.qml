import QtLocation 5.3
import QtQuick 2.5
import QtPositioning 5.2
import Sailfish.Silica 1.0

import org.blogreen 1.0

Page {
    id: page

    property variant teredata: []
    property int current_time: Date.now() / 1000
    property int routeId: 0

    function hasAlreadyPassed(model) {
        return model.departureTimestamp < current_time
    }

    Timer {
        running: true
        repeat: true
        onTriggered: {
            page.current_time = Date.now() / 1000
        }
    }

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        x: 0
        y: 0
        width: page.isLandscape ? parent.width / 2 : parent.width
        height: page.isLandscape ? parent.height : parent.height / 2

        header: PageHeader {
            title: qsTr("Bus Stops")
        }

        model: ListModel {
            id: stops
        }

        delegate: ListItem {
            id: delegate

            width: ListView.view.width
            height: Theme.itemSizeMedium

            onClicked: {
                console.log(model.departure)
                map.center = QtPositioning.coordinate(model.stopInfo.position.lat, model.stopInfo.position.lng)
                map.zoomLevel = map.maximumZoomLevel

            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin

                Label {
                    text: stopInfo.name
                    color: hasAlreadyPassed(model) ? Theme.errorColor : (delegate.highlighted ? Theme.highlightColor : Theme.primaryColor)


                }
                Label {
                    text: model.arrival
                    font.pixelSize: Theme.fontSizeSmall
                    color: hasAlreadyPassed(model) ? Theme.errorColor : (delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor)

                }
            }
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
            model: listView.model

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.stopInfo.position.lat, model.stopInfo.position.lng)

                anchorPoint.x: marker.width * 0.5
                anchorPoint.y: marker.height

                function src(m) {
                    if (hasAlreadyPassed(m))
                        return "qrc:///images/marker-blue.png";
                    else
                        return "qrc:///images/marker-green.png";
                }

                sourceItem: Column {
                    id: marker
                    Text {
                        text: model.stopInfo.name
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter

                        visible: false
                    }
                    Image {
                        id: image
                        source: src(model)
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    Timer {
        running: true
        interval: 1000
        repeat: false

        onTriggered: {
            var latitudes = []
            var longitudes = []

            for (var i = 0; i < listView.model.count; i++) {
                latitudes.push(listView.model.get(i).stopInfo.position.lat)
                longitudes.push(listView.model.get(i).stopInfo.position.lng)
            }

            var tl = QtPositioning.coordinate(Math.max.apply(null, latitudes), Math.min.apply(null, longitudes))
            var br = QtPositioning.coordinate(Math.min.apply(null, latitudes), Math.max.apply(null, longitudes))

            map.fitViewportToGeoShape(QtPositioning.rectangle(tl, br))
        }
    }

    Component.onCompleted: {
        var stops = []
        var i

        // We are only interested in the values of the provided hash
        for (i in teredata) {
            stops.push(teredata[i])
        }

        // In JS, Map items are unordered, so we need to sort the list again
        for (i in stops.sort(function (a, b) { return a['arrival'].localeCompare(b['arrival']) })) {
            listView.model.append(stops[i])
        }
    }
}
