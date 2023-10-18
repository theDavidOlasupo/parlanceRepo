import QtQuick.Controls 2.2
import QtQuick.Window 2.3

import "pages"

ApplicationWindow {
    id: window
    visible: true
    width: 1440
    height: 900
    title: "Parlance"
    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint // https://bugreports.qt.io/browse/QTBUG-64574

    property bool isLandscape: width >= height;
    property bool isTVOS: true;

    Root { anchors.fill: parent }

}
