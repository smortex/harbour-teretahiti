import QtQuick 2.5
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0
import QtLocation 5.3
import QtPositioning 5.2

import org.blogreen 1.0

Page {
    allowedOrientations: Orientation.All

    TabView {
        model: [mapTab, test]

        anchors.fill: parent
        currentIndex: 0
        //interactive: false

        header: TabBar {
            model: tabModel
        }

        Component {
            id: mapTab

            TabItem {
                Flickable {
                    PullDownMenu {
                        id: menu
                        MenuItem {
                            text: "refresh"
                            onClicked: {
                                menu.busy = true
                                var req = new XMLHttpRequest()
                                req.onreadystatechange = function() {
                                    if (req.readyState === XMLHttpRequest.DONE) {
                                        menu.busy = false
                                        bus_stop_model.update(req.responseText)
                                    }
                                }
                                req.open('GET', 'http://locbusrtct.dataccessor.com:20082/api/places/all')
                                req.send()
                            }
                        }
                    }

                    anchors.fill: parent
                    clip: true
                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                    }
                    Plugin {
                        id: mapPlugin
                        name: "osm"
                    }

                    Map {
                        id: map
                        anchors.fill: parent
                        plugin: mapPlugin

                        zoomLevel: 8

                        Component.onCompleted: {
                            console.info(map.center.isValid)
                            console.info(map.center.latitude)
                            console.info(map.center.longitude)
                            map.center = QtPositioning.coordinate(-17.6483, -149.4923)

                        }

                        MapItemView {
                            model: BusStopModel {
                                id: bus_stop_model
                            }
                            delegate: MapQuickItem {
                                coordinate: QtPositioning.coordinate(model.latitude, model.longitude)

                                anchorPoint.x: marker.width * 0.5
                                anchorPoint.y: marker.height

                                sourceItem: Column {
                                    id: marker
                                    Text {
                                        text: model.name
                                        font.bold: true
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Image {
                                        id: image
                                        source: "https://maps.gstatic.com/mapfiles/ridefinder-images/mm_20_red.png"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
        Component {
            id: test
            TabItem {
                Rectangle {
                    anchors.fill: parent
                    color: "#ff0000"
                }
            }
        }
    }
    ListModel {
        id: tabModel

        ListElement {
            title: qsTrId("Map")
        }
        ListElement {
            title: qsTrId("Tset")
        }
    }
}

