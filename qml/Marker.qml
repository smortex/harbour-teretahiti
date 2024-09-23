import QtQuick 2.0
import QtLocation 5.3

MapQuickItem
{
    id: marker
    anchorPoint.x: marker.width / 2
    anchorPoint.y: marker.height / 2
    sourceItem: Image
    {

        Image
        {
            id: icon
            source: "image://theme/icon-m-favorite-selected?" + Theme.highlightColor
            sourceSize.width: 40
            sourceSize.height: 40
        }

    }

}
