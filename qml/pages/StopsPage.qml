import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: page

    property variant teredata: []

    Component.onCompleted: {
        /*
        for(var i=0; i < teredata.count; i++) {
            console.log(i)
            stops.append(teredata.get(i))
        }
        */
        listView.model = teredata
    }

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Bus Stops")
        }

        model: ListModel {
            id: stops
        }

        delegate: ListItem {
            id: delegate

            width: ListView.view.width
            height: Theme.itemSizeSmall

            onClicked: {
                console.log(model.id)
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
