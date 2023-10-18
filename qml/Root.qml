import Parlance 1.0
import QtGamepad 1.0
import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Window 2.3

import MeasurementProtocol 1.0

import "controls"
import "logic"
import "model"
import "pages"

Item {

    // app initialization
    Component.onCompleted: {

//        console.log("Screen.pixelDensity: " + Screen.pixelDensity)
//        console.log("Screen.devicePixelRatio: " + Screen.devicePixelRatio)

//        console.log("locale:", Qt.locale().name)

//        if(isOnline) {
//            logic.clearCache()
//        }

        logic.fetchStreams()
    }

    Connections {
        target: GamepadManager
        function onGamepadConnected() {
//            console.log("deviceID connected:" + deviceId);
           // gamepad1.deviceId = deviceId
        }
    }

    Connections {
        target: Qt.application
        function onStateChanged() {
            // this is to bypass the 'No Now Playing notification [card]' violation. If the app
            // goes into the backgroup, kill it so we don't need to display any "Now Playing".
            if (Qt.platform.os === "android" && Qt.application.state !== Qt.ApplicationActive) {
                Qt.quit();
            }
        }
    }

    UniversalGamepad {
        id: gamepad1
     }

    FontLoader { id: fontAwesome; source: "qrc:/fontawesome-webfont.ttf" }

    Logic {
        id: logic
    }

    DataModel {
        id: dataModel
        dispatcher: logic
        onFetchStreamsSucceeded: {
            var item = stackView.push("pages/StreamsPage.qml")
            item.title = "ontla"
            splashScreenTimeout.start()
        }
        onFetchStreamsFailed: {
            //nativeUtils.displayMessageBox(qsTr("Unable to load list of streams"), error, 1)
        }
    }


    StackView {
        id: stackView
        anchors.fill: parent
        onCurrentItemChanged: {
            if (currentItem) {
                currentItem.forceActiveFocus()
            }
        }
    }

    Rectangle {
        id: splashScreen
        color: "white"
        x: 0
        y: 0
        width: parent.width
        height: parent.height

        Behavior on x {
            SmoothedAnimation  {velocity: 400}
        }
        Behavior on y {
            SmoothedAnimation  {velocity: 400}
        }

        Behavior on opacity {
            SmoothedAnimation  {velocity: 0.75}
        }

        Image {
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "banner.png"


            Image {
                x: parent.width * 0.3198
                height: parent.height
                source: "banner_center.png"
                fillMode: Image.PreserveAspectFit
                RotationAnimation on rotation {
                    loops: Animation.Infinite
                    duration:2000
                    from: 0
                    to: 360
                }
            }
        }
    }

    Timer {
        id: splashScreenTimeout
        onTriggered: {
            switch(getRandomInt(4))
            {
            case 0:
                splashScreen.x = window.width;
                break;
            case 1:
                splashScreen.x = -window.width;
                break;
            case 2:
                splashScreen.y = window.height;
                break;
            case 3:
                splashScreen.y = -window.height;
                break;
            }
            splashScreen.opacity = 0
        }
    }

    function msToTime(s) {

        function pad(n, z) {
            z = z || 2;
            return ('00' + n).slice(-z);
        }

        var ms = s % 1000;
        s = (s - ms) / 1000;
        var secs = s % 60;
        s = (s - secs) / 60;
        var mins = s % 60;
        var hrs = (s - mins) / 60;

        return pad(hrs) + ':' + pad(mins) + ':' + pad(secs);
    }

    property real dpScale: Screen.pixelDensity / Screen.devicePixelRatio / 3.685613777652585 // (160dpi in pixelpermillimieter)

    function dp(pixel) {
         return pixel * dpScale;
    }

    function getRandomInt(max) {
      return Math.floor(Math.random() * Math.floor(max));
    }

}
