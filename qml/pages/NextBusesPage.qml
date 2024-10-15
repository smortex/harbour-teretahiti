import QtQuick 2.5
import Sailfish.Silica 1.0

import org.blogreen 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property variant teredata: []
    property int now: Date.now() / 1000

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
          if (ts == null || ts > model.stopTimes[i].arrivalTimestamp)
            ts = model.stopTimes[i].arrivalTimestamp;
      }

      return ts
    }
    function lastTimestamp(model) {
      var ts = null
      for (var i in model.stopTimes) {
          if (ts == null || ts < model.stopTimes[i].arrivalTimestamp)
            ts = model.stopTimes[i].arrivalTimestamp;
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
        anchors.fill: parent
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
//                for (var prop in model.stopTimes) {
//                    data.push(model.stopTimes[prop])
//                }

                console.info(JSON.stringify(model.stopTimes))

                pageStack.push(Qt.resolvedUrl("StopsPage.qml"), { teredata: model.stopTimes })
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
              Rectangle {
                height: delegate.height - title.height - details.height
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
}
