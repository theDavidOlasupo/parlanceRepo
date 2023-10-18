import QtQuick 2.0

Item {
    property alias size: textItem.font.pixelSize
    property alias color: textItem.color
    property alias icon: textItem.text
    property alias textItem: textItem
    property real pixelSize: Qt.application.font.pixelSize * 1.5

    width: pixelSize;
    height: pixelSize;

    Text {
        id:textItem
        font.family: fontAwesome.name
        anchors.centerIn: parent
        font.pixelSize: parent.pixelSize
    }

}
