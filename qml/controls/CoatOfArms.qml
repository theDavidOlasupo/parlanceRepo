import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.3

Item {
    id: root
    width: dp(408)
    height: width * 3.1

    Rectangle {
        anchors.fill: parent
        color: Material.background
        radius: 12.5
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 0
        Text {
            Layout.maximumWidth: root.width*0.38
            Layout.fillHeight: true
            text: "Legislative\nAssembly\nof Ontario"
            color: "#0b0b00"
            font.family: "Times"
            font.bold: true
            font.pixelSize: root.height/6
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Image {
            Layout.maximumWidth: root.width*0.24
            Layout.fillHeight: true
            smooth: true
            fillMode: Image.PreserveAspectFit
            source: "../coat_of_arms.png"
        }

        Text {
            Layout.maximumWidth: root.width*0.38
            Layout.fillHeight: true
            text: "Assemblée\nlégislative\nde l'Ontario"
            color: "#0b0b00"
            font.family: "Times"
            font.bold: true
            font.pixelSize: root.height/6
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

}
