import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtMultimedia 5.12
import QtQuick.Controls.Material 2.3
import Parlance 1.0


import "../util"


Rectangle {

    property alias muted: player.muted
    property alias videoUrl: player.source
    property alias playbackState: player.playbackState
    property alias isBusy: player.isBusy
    property alias isPlaying : player.isPlaying
    property alias isPaused : player.isPaused
    property alias isStopped : player.isStopped
    property alias position : player.position
    property alias duration : player.duration

    property bool fullscreen: false

    color: "black"
    clip: true

    function play() {
        if (!player.isBusy) player.play();
    }

    function pause() {
        if (!player.isBusy) player.pause();
    }

    function stop() {
        if (!player.isBusy) player.stop();
    }

    MediaPlayer {
        id: player
        autoPlay: true;
        audioRole: MediaPlayer.VideoRole
        property bool isBusy : false
        property bool isPlaying : false
        property bool isPaused : false
        property bool isStopped : false
        onStatusChanged: {
            switch(status) {
            case MediaPlayer.NoMedia: // no media has been set.
//                console.log('player.status=NoMedia');
                isBusy = false;
                break;
            case MediaPlayer.Loading: // the media is currently being loaded.
//                console.log('player.status=Loading');
                isBusy = true;
                break;
            case MediaPlayer.Loaded: // the media has been loaded.
//                console.log('player.status=Loaded');
                isBusy = false;
                break;
            case MediaPlayer.Buffering: // the media is buffering data. . Implies that we're no longer stalled if we were stalled.
//                console.log('player.status=Buffering');
                isBusy = false;
                break;
            case MediaPlayer.Stalled: //  playback has been interrupted while the media is buffering data.
//                console.log('player.status=Stalled');
                isBusy = true; // video is interrupted because of the lack of buffer, so we need to show the activity indicator.
                break;
            case MediaPlayer.Buffered: // the media has buffered data.
//                console.log('player.status=Buffered');
                // Implies that we're no longer stalled if we were stalled.
                isBusy = false;
                break;
            case MediaPlayer.EndOfMedia: //  the media has played to the end.
//                console.log('player.status=EndOfMedia');
                isBusy = false;
                break;
            case MediaPlayer.InvalidMedia: //  the media cannot be played.
//                console.log('player.status=InvalidMedia');
                isBusy = false;
                break;
            case MediaPlayer.UnknownStatus: // the status of the media is unknown.
//                console.log('player.status=UnknownStatus');
                isBusy = false;
                break;
            default:
//                console.log('player.status=' + status);
                break;
            }
        }
        onMediaObjectChanged: {
//            console.log("MediaObject: " + JSON.parse(mediaObject));
        }

        onPlaybackStateChanged: {
            switch(playbackState) {
            case MediaPlayer.PlayingState:
//                console.log("player.playbackState=Playing");
                isPlaying = true;
                isPaused = false;
                isStopped = false;
                isBusy = false;
                break;
            case MediaPlayer.PausedState:
//                console.log("player.playbackState=PausedState");
                isPlaying = false;
                isPaused = true;
                isStopped = false;
                break;
            case MediaPlayer.StoppedState:
//                console.log("player.playbackState=StoppedState");
                isPlaying = false;
                isPaused = false;
                isStopped = true;
                break;
            default:
//                console.log("player.playbackState=" + playbackState);
                break;
            }
        }

        onError: {

            switch(error) {
            case MediaPlayer.NoError:
                return;
            case MediaPlayer.ResourceError:
                errorText.text = qsTr("The video cannot be played due to a problem allocating resources.")
                break;
            case MediaPlayer.FormatError:
                errorText.text = qsTr("The video format is not supported.")
                break;
            case MediaPlayer.NetworkError:
                errorText.text = qsTr("The video cannot be played due to network issues.")
                break;
            case MediaPlayer.AccessDenied:
                errorText.text = qsTr("The video cannot be played due to insufficient permissions.")
                break;
            case MediaPlayer.ServiceMissing:
                errorText.text = qsTr("The video cannot be played because the media service could not be instantiated.")
                break;
            default:
                return;
            }
        }
    }

    VideoOutput {
        id: videoOutput
        source: player
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectFit
    }

    Rectangle {
        id: blinder
        anchors.fill: parent
        color: "black"
        opacity: player.isBusy ? 0.75 : 0.0
        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: player.isBusy;
    }

    Rectangle { // error bubble
        property bool display: player.error !== MediaPlayer.NoError
        opacity: display ? 1.0 : 0.0;
        scale: display ? 1.0 : 0.0;
        color: Material.primary
        border.width: dp(5)
        border.color: Material.foreground
        radius: 12.5
        anchors.centerIn: parent
        width: isLandscape? page.width * 0.28 : page.width * 0.45
        height: width * 0.3

        Text {
            x: errorText.x + dp(2)
            y: errorText.y + dp(2)
            width: errorText.width
            height: errorText.height
            color: "#0b0b00"
            fontSizeMode: errorText.fontSizeMode
            wrapMode: errorText.wrapMode
            verticalAlignment: errorText.verticalAlignment
            minimumPixelSize: errorText.minimumPixelSize
            font: errorText.font
            text: errorText.text
        }

        Text {
            id: errorText
            anchors.centerIn: parent
            width: parent.width * 0.80
            height: parent.height * 0.80
            color: Material.foreground
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            minimumPixelSize: dp(10) // minimum
            font.pixelSize: dp(72) // maximum
        }

    }
}

