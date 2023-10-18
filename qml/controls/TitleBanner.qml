import QtQuick 2.0
import QtQuick.Controls.Material 2.3

Item {
    width: row.width
    height: 245

    Row {
        id: row
        height: parent.height
        Image {
            id: logo
            height: parent.height
            source: "../title_logo.png"
            fillMode: Image.PreserveAspectFit
        }
        Image {
            height: parent.height
            source: "../title_front_cap.png"
            fillMode: Image.PreserveAspectFit
        }
        Image {
            height: parent.height
            width: titleText.width * 1.5
            source: "../title_bg.png"
            Text {
                id: titleText
                text: qsTr("Live Broadcasts")
                color: Material.primary
                font.bold: true
                font.pixelSize: parent.height/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Image {
            height: parent.height
            source: "../title_end_cap.png"
            fillMode: Image.PreserveAspectFit
        }
    }

}
