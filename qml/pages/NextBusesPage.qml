import QtQuick 2.5
import Sailfish.Silica 1.0

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
            height: Theme.itemSizeSmall

            onClicked: {
                var data = []
                for (var prop in model.stopTimes) {
                    data.push(model.stopTimes[prop])
                }

                pageStack.push(Qt.resolvedUrl("StopsPage.qml"), { teredata: data })
            }

            Label {
                text: name

                //font.capitalization: Font.Capitalize

                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
            }
        }

        VerticalScrollDecorator {}
    }
}
