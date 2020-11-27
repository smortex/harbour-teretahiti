import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Bus Lines")
                onClicked: {
                    var req = new XMLHttpRequest()
                    req.onreadystatechange = function() {
                        if (req.readyState === XMLHttpRequest.DONE) {
                            var data = JSON.parse(req.responseText)['data'];
                            pageStack.push(Qt.resolvedUrl("LinesPage.qml"), { teredata: data })
                        }
                    }
                    req.open('GET', 'http://locbusrtct.dataccessor.com:20082/api/routes/0')
                    req.send()

                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("UI Template")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Hello Sailors")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
        }
    }
}
