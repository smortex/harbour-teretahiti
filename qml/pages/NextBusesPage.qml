import QtQuick 2.5
import Sailfish.Silica 1.0

import org.blogreen 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property variant teredata: []

    Component.onCompleted: {
        teredata.forEach(function(itm) {
            console.log(itm.name)
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

            onClicked: {
                var data = []
//                for (var prop in model.stopTimes) {
//                    data.push(model.stopTimes[prop])
//                }

                console.info(JSON.stringify(model.stopTimes))

                pageStack.push(Qt.resolvedUrl("StopsPage.qml"), { teredata: model.stopTimes })
            }

            function firstTimestamp(model) {
              var ts = null
              for (var i in model.stopTimes) {
                  if (ts == null || ts < model.stopTimes[i].arrivalTimestamp)
                    ts = model.stopTimes[i].arrivalTimestamp;
              }

              return ts;
            }
            function lastTimestamp(model) {
              var ts = null
              for (var i in model.stopTimes) {
                  if (ts == null || ts > model.stopTimes[i].arrivalTimestamp)
                    ts = model.stopTimes[i].arrivalTimestamp;
              }

              return ts;
            }
            Rectangle {
              height: parent.height
              width: parent.width * (1 - (Date.now() / 1000 - firstTimestamp(model)) / (lastTimestamp(model) - firstTimestamp(model)))
              color: Theme.highlightBackgroundColor
            }

            Column {
              anchors.verticalCenter: parent.verticalCenter
              x: Theme.horizontalPageMargin

              Label {
                text: name
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                //font.capitalization: Font.Capitalize
              }
              Row {
                spacing: Theme.paddingMedium

                Label {
                  text:model.startTime
                  font.pixelSize: Theme.fontSizeSmall
                  color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
                Label {
                  text: model.endTime
                  font.pixelSize: Theme.fontSizeSmall
                  color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }
              }
            }

        }

        ViewPlaceholder {
          enabled: listView.count == 0
          text: qsTr("Fin de service")
          hintText: qsTr("Aucun bus proposé")
        }
        VerticalScrollDecorator {}
    }
}
