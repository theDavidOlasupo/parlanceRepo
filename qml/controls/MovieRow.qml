import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGamepad 1.0

Item {
    id: cell
    width: parent ? parent.width : 0
    height: window.width*4/9 + dp(11 * 2)
    clip: true

    property string title: ""
    property string overview: ""
    property string posterSource: ""
    property string backdropSource: ""
    property real scrollPosition: 0
    property bool active: false
    signal selected()

    Rectangle {
        color: Material.background
        anchors.fill: parent
    }

    Image {
        id: backdrop
        y: (cell.scrollPosition) * (cell.height-height)
        width: parent.width
        source: backdropSource
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        smooth: true
        cache: true
    }

    Rectangle {
        anchors.fill: backdrop
        color: Material.background
    }

    FastBlur {
        id: blur
        source: backdrop
        anchors.fill: backdrop
        radius: 24
        cached: true
        opacity: (backdrop.status === Image.Ready) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 1000 } }
    }

    RowLayout {
        anchors.fill: parent;
        spacing: 0
        Item {
            Layout.margins: dp(11)
            Layout.minimumWidth: window.width/3
            Layout.minimumHeight: window.width*4/9
            Layout.preferredWidth: window.width/3
            Layout.preferredHeight: window.width*4/9
            Layout.maximumWidth: window.width/3
            Layout.maximumHeight: window.width*4/9
            Layout.fillWidth: false
            Layout.fillHeight: false

            Rectangle {
                id: poster
                color: "white"
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                Image {
                    id: posterImage
                    width: poster.width
                    height: poster.height
                    scale: active ? (1.0 - Math.abs(gamepad1.axisLeftY*0.4) ): 0.5
                    source: cell.posterSource
                    sourceSize.width: poster.width
                    sourceSize.height: poster.height
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    opacity: (status === Image.Ready) ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 1000 } }
                    Behavior on scale { SpringAnimation { spring: 2; damping: 0.3 } }
                }
                BusyIndicator{
                    anchors.centerIn: posterImage
                    running: posterImage.status === Image.Loading
                    opacity: (posterImage.status === Image.Ready) ? 0.0 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 1000 } }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    opacity: 1.0 - posterImage.scale
                }
            }
            DropShadow {
                anchors.fill: poster
                radius: 8.0
                samples: 17
                color: "#cf000000"
                source: poster
            }

        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.rightMargin: dp(11)
            Layout.minimumWidth: dp(42)
            Layout.minimumHeight: window.width*4/9
            Layout.maximumHeight: window.width*4/9
            color: "#af000000"

            ColumnLayout {
                anchors.fill: parent;
                spacing: 0
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    Layout.margins: dp(11)
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.minimumHeight: dp(18*1.5)
                    Layout.maximumHeight: dp(18*1.5)
                    Text { // Shadow text
                        x: dp(1)
                        y: dp(1)
                        width: parent.width
                        height: parent.height
                        verticalAlignment: Text.AlignTop
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        color: "black"
                        font.bold: true
                        text: cell.title
                        font.pixelSize: dp(24)
                    }
                    Text {
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignTop
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        color: "white"
                        font.bold: true
                        text: cell.title
                        font.pixelSize: dp(24)
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: dp(11)
                    Layout.rightMargin: dp(11)
                    Layout.bottomMargin: dp(11)
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Text { // Shadow text
                        x: dp(1)
                        y: dp(1)
                        width: parent.width
                        height: parent.height
                        verticalAlignment: Text.AlignTop
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        color: "black"
                        text: cell.overview
                        font.pixelSize: dp(18)
                    }
                    Text {
                        anchors.fill: parent;
                        verticalAlignment: Text.AlignTop
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        color: "white"
                        text: cell.overview
                        font.pixelSize: dp(18)
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            selected()
        }
    }

    Gamepad {
        id: gamepad1
        property bool thumbUp: false
        property bool thumbDown: false
        deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
    }

    Connections {
        target: GamepadManager
        function onGamepadConnected() {
            gamepad1.deviceId = deviceId;
        }
    }
}
