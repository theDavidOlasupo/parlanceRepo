import QtQuick 2.0
import QtMultimedia 5.9
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.5

import "../pages"
import "../util"

Item {
    id: container
    z: focus ? 1 : 0

    property alias player : player
    property alias fullscreen: player.fullscreen
    property real axisLeftX : 0
    property real axisLeftY : 0
    property string videoUrl
    property string videoCCUrl
    property string title: ""
    property bool closedCaptioningEnabled: false
    property bool closedCaptioningAvailable: videoCCUrl !== ""

    function applySource() {
        if (closedCaptioningEnabled === true && videoCCUrl !== "") {
            player.videoUrl = videoCCUrl;
        } else {
            player.videoUrl = videoUrl;
        }
    }

    onVideoUrlChanged: applySource();
    onVideoCCUrlChanged: applySource();
    onClosedCaptioningEnabledChanged: applySource();

    Keys.onPressed: {
        console.log("PlayerContainer Key event: " + event.key.toString(16)); // https://doc.qt.io/qt-5/qt.html#Key-enum

        if (fullscreen)
        {
            controls.show();
        }

       // controls.show();

        cursor.visible = true;

        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Select || event.key === Qt.Key_Space) {
            if (!fullscreen)
            {
                fullscreen = true;
                controls.state = "playPauseButtonSelected";
                player.play();
            }
            else
            {
                if (controls.state === "playPauseButtonSelected")
                {
                    if (player.playbackState === MediaPlayer.PlayingState)
                    {
                        player.pause();
                    }
                    else
                    {
                        player.play();
                    }
                }
                else if (controls.state === "closedCaptioningButtonSelected")
                {
                    closedCaptioningEnabled = !closedCaptioningEnabled;
                }
            }
        }
        else if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape || (isTVOS && event.key === Qt.Key_Menu))  {
            if (fullscreen)
            {
                fullscreen = false
            }
            else if (focus)
            {
                nullPlayerContainer.focus = true;
            }
            event.accepted = true;
        }
        else if (event.key === Qt.Key_Play || event.key === Qt.Key_MediaPlay)
        {
            controls.state = "playPauseButtonSelected";
            player.play();
        }
        else if (event.key === Qt.Key_Pause || event.key === Qt.Key_MediaPause)
        {
            controls.state = "playPauseButtonSelected";
            player.pause();
        }
        else if (event.key === Qt.Key_Stop || event.key === Qt.Key_MediaStop)
        {
            controls.state = "playPauseButtonSelected";
            player.stop();
        }
        else if (event.key === Qt.Key_MediaTogglePlayPause)
        {
            controls.state = "playPauseButtonSelected";
            if (player.playbackState === MediaPlayer.PlayingState)
            {
                player.pause();
            }
            else
            {
                player.play();
            }
        }
        else if (event.key === Qt.Key_Left)
        {
            controls.state = "playPauseButtonSelected";
        }
        else if (event.key === Qt.Key_Right)
        {
            if (closedCaptioningAvailable)
            {
                controls.state = "closedCaptioningButtonSelected";
            }
        }
    }

    onAxisLeftXChanged: {
        if (player.fullscreen)
        {
            controls.show();
        }
    }

    onAxisLeftYChanged: {
        if (player.fullscreen)
        {
            controls.show();
        }
    }

    VideoPlayerPage {
        id: player
        muted: !container.focus
        state: "miniscreen"
        scale: {
            if (fullscreen) {
                // we are full screen. do nothing.
                return 1.1;
            }
            else if (container.focus) {
                // if we are focussed,.we are highlighted., we can only shrink.
                return 1.1 + 0.1*Math.min(0, axisLeftX) - (0.1*Math.abs(axisLeftY))
            }
            else {
                // if we are not focussed,.we can only grow.
                return 1.0 + 0.1*Math.max(0, axisLeftX)
            }
        }
        Behavior on scale {
            SmoothedAnimation { velocity: 0.75 }
        }

        onFullscreenChanged: {
            if (fullscreen) {
                state = "fullscreen";
                controls.show(); //makes the controllers show the first time the video goes fullscreen on the stream page
            }
            else {
                state = "miniscreen";
                controls.hide();
            }
        }

        states: [
            State {
                name: "fullscreen"
                ParentChange {
                    target: player
                    parent: page
                    x: ((page.width) - (page.width/1.1)) * 0.5
                    y: ((page.height) - (page.height/1.1)) * 0.5
                    width: page.width / 1.1
                    height:page.height / 1.1
                }
            },
            State {
                name: "miniscreen"
                ParentChange {
                    target: player
                    parent: container
                    x: (container.width - width) * 0.5
                    y: (container.height - height - titleText.height) * 0.5


                   // width: Math.min((container.height - titleText.height) * 1.77777778, container.width)
                    //height: Math.min(container.width / 1.77777778, container.height - titleText.height)
                    width: Math.min((container.height - titleText.height) * 1.77777778, container.width)
                    height: Math.min(container.width / 1.77777778, container.height - titleText.height)
                }
            }
        ]
        transitions: Transition {
            ParentAnimation {
                SmoothedAnimation { properties: "x,y,width,height"; duration: 500 }
            }
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
//                console.log("PlayerContainer: screen onClick");
                // won't happen if we only use the remote control.
                backButton.visible = true;
                if (!player.fullscreen) {
                    container.forceActiveFocus();
                    player.fullscreen = true;
                    player.play();
                } else {
                    controls.show()
                }
            }
            enabled: !isTVOS
        }

        Connections {
            target: gamepad1
            function onA() {
                if (!isTVOS && player.fullscreen) {
                   console.log("PlayerContainer: A pressed!");
                    controls.show()
                    if (controls.state === "playPauseButtonSelected")
                    {
                        if (player.playbackState === MediaPlayer.PlayingState)
                        {
                            player.pause();
                        }
                        else
                        {
                            player.play();
                        }
                    }
                    else if (controls.state === "closedCaptioningButtonSelected")
                    {
                        closedCaptioningEnabled = !closedCaptioningEnabled;
                    }
                }
            }

            function onX() {
                if (!isTVOS && player.fullscreen) {
                   console.log("PlayerContainer onX() : X pressed!");
                    controls.show()
                    if (player.playbackState === MediaPlayer.PlayingState) {
                        player.pause();
                    } else {
                        player.play();
                    }
                }
            }

            function onLeft() {
                if (player.fullscreen) {
                   console.log("PlayerContainer: Left pressed!");
                    controls.show()
                    controls.state = "playPauseButtonSelected";
                }
            }

            //todo
            function onRight() {
                if (player.fullscreen) {
                  console.log("PlayerContainer: Right pressed!");
                    controls.show()
                    controls.state = "closedCaptioningButtonSelected";
                }
            }
        }

        Rectangle {
            id: backButton
            x: dp(-10)
            y: dp(-10)
            width: dp(100)
            height: dp(100)
            color: Material.primary
            border.width: dp(5)
            border.color: Material.foreground
            radius: 12.5
            opacity: visible && fullscreen ? 0.75 : 0.0
            visible: false
            Behavior on opacity { NumberAnimation { duration: 250 } }

            Behavior on y {  SmoothedAnimation { duration: 500 } }

            Icon {
                id: backIcon
                x: dp(11)
                y: dp(18)
                color: Material.foreground
                pixelSize: dp(73)
                icon: IconType.chevronleft
            }

            MouseArea {
                id: backHitZone
                enabled: fullscreen && !isTVOS
                anchors.fill: parent;
                onClicked: {
                    fullscreen = false;
                }
            }


        }

        Timer {
            id: autoHideControlsTimer
            interval: 5000;
            running: true;
            onTriggered: {
                controls.hide();
            }
        }

        Item {
            id: controls
            width: parent.width
            height: parent.height
            opacity: 0.75
            x: 0
            y: dp(130)

            states: [
                State {
                    name: "noButtonSelected"
                },
                State {
                    name: "playPauseButtonSelected"
                    ParentChange { target: cursor; parent: playPauseButton; x: (parent.width - cursor.width)/2; y: (parent.height - cursor.height)/2}
                },
                State {
                    name: "closedCaptioningButtonSelected"
                    ParentChange { target: cursor; parent: closedCaptioningButton; x: (parent.width - cursor.width)/2; y: (parent.height - cursor.height)/2}
                }
            ]
            transitions: Transition {
                ParentAnimation {
                    SmoothedAnimation { properties: "x,y"; duration: 500 }
                }
            }

            state: "noButtonSelected"

            Rectangle {
                x: 0
                y: parent.height - height;
                width: parent.width;
                height: dp(130);
                color: Material.primary
                border.width: dp(5)
                border.color: Material.foreground
                radius: 12.5
            }

            Behavior on y {  SmoothedAnimation { duration: 500 } }

            function hide() {
                controls.y = dp(130);
                backButton.y = dp(-110) //set the back button to hide and move out of the screen with the controllers

            }

            function show() {
                controls.y = 10;
                backButton.y = dp(10); //shows the back button alongside the controls

                autoHideControlsTimer.restart();
            }

            RowLayout {
                id: controlsRow
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom
                anchors.leftMargin: dp(36)
                anchors.rightMargin: dp(36)
                spacing: dp(36)
                height: dp(130)

                Item {
                    id: playPauseButton
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignLeft
                    Layout.fillHeight: true
                    width: dp(58)

                    Icon {
                        id: pauseIcon
                        anchors.centerIn: parent
                        icon: IconType.pause
                        color: Material.foreground
                        pixelSize: dp(48)
                        visible: player.isPlaying
                    }

                    Icon {
                        id: playIcon
                        anchors.centerIn: parent
                        icon: IconType.play
                        color: Material.foreground
                        pixelSize: dp(48)
                        visible: !player.isPlaying
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            if (player.isPlaying) {
                                player.pause();
                            } else {
                                player.play();
                            }
                        }
                        enabled: !isTVOS
                    }
                }

                ProgressBar {
                    id: videoProgressBar
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignLeft
                    indeterminate: player.duration <= 0
                    value: player.duration > 0 ? player.position / player.duration: 0;

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.bottomMargin: dp(24)
                        font.pixelSize: dp(24);
                        text: msToTime(player.position) + " / " + msToTime(player.duration)
                        color: Material.foreground
                    }
                }

                Item {
                    id: closedCaptioningButton
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignLeft
                    Layout.fillHeight: true
                    width: dp(58)
                    visible: closedCaptioningAvailable
                    Behavior on opacity { NumberAnimation { duration: 500 } }

                    Icon {
                        id: closedCaptioningIcon
                        anchors.centerIn: parent
                        icon: IconType.cc
                        color: Material.foreground
                        pixelSize: dp(48)
                        opacity: closedCaptioningEnabled ? 1.0 : 0.4
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            closedCaptioningEnabled = !closedCaptioningEnabled;
                        }
                        enabled: !isTVOS
                    }
                }

                Item {
                    id: liveIndicator
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignLeft
                    Layout.fillHeight: true
                    width: dp(58)
                    visible: player.duration <= 0

                    Icon {
                        id: liveIcon
                        anchors.centerIn: parent
                        icon: IconType.circle
                        color: "red"
                        pixelSize: dp(48)

                        Text {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottomMargin: dp(-12)
                            font.pixelSize: dp(12);
                            font.bold: true
                            font.italic: true
                            text: qsTr("LIVE")
                            color: Material.foreground
                        }
                    }
                }
            }

            Item {
                id: cursor
                x: 0
                y: parent.height
                width: dp(68)
                height: dp(68)
                visible: false

                Rectangle {
                    x: -axisLeftX * parent.width/4;
                    y: axisLeftY * parent.width/4;
                    width: parent.width
                    height: parent.width
                    color: "#3fffffff"
                    border.width: dp(5)
                    border.color: Material.foreground
                    radius: 12.5
                }

            }


        }
    }

    Text {
        id: titleTextShadow
        x: titleText.x + dp(2)
        y: titleText.y + dp(2)
        color: "#0b0b00"
        text: container.title
        font.pixelSize: container.width * 0.05 //change font of the title
    }

    Text {
        id: titleText
        anchors.horizontalCenter: player.horizontalCenter
        anchors.top: player.bottom
        anchors.topMargin: (player.scale - 1.0) * 100.0
        color: Material.foreground
        text: container.title
        font.pixelSize: container.width * 0.05 //change font of the video title
    }

    Connections {
        target: Qt.application
        function onStateChanged() {
            switch (Qt.application.state) {
            case Qt.ApplicationSuspended:
            case Qt.ApplicationHidden:
                player.pause();
                break
            case Qt.ApplicationActive:
                player.play();
                break
            }
        }
    }

}
