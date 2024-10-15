import QtQuick 2.5
import Sailfish.Silica 1.0

import org.blogreen 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            id: menu
            MenuItem {
                text: qsTr("Refresh Bus Lines")
                onClicked: {
                    menu.busy = true
                    var req = new XMLHttpRequest()
                    req.onreadystatechange = function() {
                        if (req.readyState === XMLHttpRequest.DONE) {
                            menu.busy = false
                            bus_line_model.update(req.responseText)
                        }
                    }
                    req.open('GET', 'http://locbusrtct.dataccessor.com:20082/api/routes/0')
                    req.send()
                }
            }
            MenuItem {
                text: "Map"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("MapPage.qml"))
                }
            }
        }

        id: listView
        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Bus Lines")
        }
//        model: ListModel {
//            id: lines
//        }
        model: BusLineModel {
            id: bus_line_model
        }


        delegate: ListItem {
            id: delegate

            width: ListView.view.width
            height: Theme.itemSizeSmall

            onClicked: {
                var req = new XMLHttpRequest()
                req.onreadystatechange = function() {
                    if (req.readyState === XMLHttpRequest.DONE) {
                        var data = JSON.parse(req.responseText)['data']
                        console.info(JSON.stringify(data))

                        pageStack.push(Qt.resolvedUrl("NextBusesPage.qml"), { teredata: data })
                    }
                }
                req.open('POST', 'http://locbusrtct.dataccessor.com:20082/api/itinerary/running')
                console.info("{\"routeId\": \"%1\"}".arg(model.id))
                req.send("{\"routeId\": \"%1\"}".arg(model.id))
            }

            function clear(color) {
                var r = parseInt(color.substring(1,3),16)/255;
                var g = parseInt(color.substring(3,5),16)/255;
                var b = parseInt(color.substring(5,7),16)/255;
//console.info(r+g+b)
                return r + g + b > 1.5
            }


            Rectangle {
                id: lineno
                height: parent.height * 0.9
                width: height
                color: model.color
                radius: 10
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    color: model.textColor || clear(model.color) ? "#000000" : "#ffffff"
                    text: model.line_number

                    anchors.centerIn: parent
                    font.weight: Font.Bold
                    font.pixelSize: Theme.fontSizeLarge
                }
            }

            Label {
                id: label
                text: name.replace(/^\d\S*\s+/, '').toLowerCase().replace(/ppt/g, 'papeete').replace(/upf/g, 'UPF').replace(/clg/g, 'collège')
                font.capitalization: Font.Capitalize

                anchors.left: lineno.right
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ViewPlaceholder {
          enabled: listView.count == 0
          text: qsTr("No bus line known")
          hintText: qsTr("Pull down to refresh the bus lines")
        }

        VerticalScrollDecorator {}
    }
}
