import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property variant teredata: []

    Component.onCompleted: {
        teredata.forEach(function(itm) {
            lines.append(itm)
        })
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Bus Lines")
        }
        model: ListModel {
            id: lines
        }


        delegate: ListItem {
            id: delegate

            width: ListView.view.width
            height: Theme.itemSizeSmall

            Rectangle {
                id: lineno
                height: parent.height * 0.9
                width: height
                color: model.color
                radius: 10
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    color: model.textColor
                    text: numCom

                    anchors.centerIn: parent
                    font.weight: Font.Bold
                    font.pixelSize: Theme.fontSizeLarge
                }
            }

            Label {
                id: label
                text: name.replace(/^\d\S*\s+/, '').toLowerCase().replace(/ppt/g, 'papeete')
                font.capitalization: Font.Capitalize

                anchors.left: lineno.right
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        VerticalScrollDecorator {}
    }
}
