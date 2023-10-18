import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGamepad 1.0
import QtMultimedia 5.9
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.3
import "../controls"

import MeasurementProtocol 1.0

Page {
    id: page

    //need to update this and push to git first
    onTitleChanged: {
        var lang = Qt.locale().name.substring(0, 2);
        console.log("Api response:"+dataModel.streams[title].toString())
        for(var i = 0; i < dataModel.streams[title].length; ++i) {

            console.log(i+": for "+title);
            if (dataModel.streams[title][i].lang.substring(0,2) === lang) {
                if (leftPlayerContainer.videoUrl.toString() === "") {
                    if (dataModel.streams[title][i].video_url) {
                        leftPlayerContainer.videoUrl = dataModel.streams[title][i].video_url;
                        leftPlayerContainer.title = dataModel.streams[title][i].title;
                    }
                    if (dataModel.streams[title][i].video_cc_url) {
                        leftPlayerContainer.videoCCUrl = dataModel.streams[title][i].video_cc_url;
                    }
                } else if (rightPlayerContainer.videoUrl.toString() === ""){
                    if (dataModel.streams[title][i].video_url) {
                        rightPlayerContainer.title = dataModel.streams[title][i].title
                        rightPlayerContainer.videoUrl = dataModel.streams[title][i].video_url;
                    }
                    if (dataModel.streams[title][i].video_cc_url) {
                        rightPlayerContainer.videoCCUrl = dataModel.streams[title][i].video_cc_url;
                    }
                }else if (bottomLeftPlayerContainer.videoUrl.toString() === "") {
                    //bottomLeftPlayerContainer
                    if (dataModel.streams[title][i].video_url) {
                        bottomLeftPlayerContainer.videoUrl = dataModel.streams[title][i].video_url;
                        bottomLeftPlayerContainer.title = dataModel.streams[title][i].title
                    }
                    if (dataModel.streams[title][i].video_cc_url) {
                        bottomLeftPlayerContainer.videoCCUrl = dataModel.streams[title][i].video_cc_url;
                    }
                } else if (bottomRightPlayerContainer.videoUrl.toString() === ""){

                    if (dataModel.streams[title][i].video_url) {
                        bottomRightPlayerContainer.videoUrl = dataModel.streams[title][i].video_url;
                        bottomRightPlayerContainer.title = dataModel.streams[title][i].title
                    }
                    if (dataModel.streams[title][i].video_cc_url) {
                        bottomRightPlayerContainer.videoCCUrl = dataModel.streams[title][i].video_cc_url;
                    }
                } else if(bottomMiddlePlayerContainer.videoUrl.toString() === ""){

                    if (dataModel.streams[title][i].video_url) {
                        bottomMiddlePlayerContainer.videoUrl = dataModel.streams[title][i].video_url;
                        bottomMiddlePlayerContainer.title = dataModel.streams[title][i].title;
                    }
                    if (dataModel.streams[title][i].video_cc_url) {
                        bottomRightPlayerContainer.videoCCUrl = dataModel.streams[title][i].video_cc_url;
                    }
                    //do ntohing all the video slots are filled
                    console.log("video filled");
                }
                else{

                }
            }
        }
    }




    Image {
        anchors.fill: parent
        source: "../background.png"
        fillMode: Image.PreserveAspectCrop;
    }

    TitleBanner {
        id: titleBanner
        height: isLandscape ?  page.height/12 : page.width/10// page.height/8 : page.width/10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.margins: dp(5) //dp(25)
    }

    Rectangle {
        id: greenRect
        anchors.top: otherRect.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
       // anchors.topMargin: dp(5) //dp(25) removed this to blur the space between the two green boxes
        anchors.bottomMargin: page.height/16 //page.height/10
        anchors.leftMargin: page.width/16//page.width/8  //was page.width/12 at nov 22
        anchors.rightMargin: page.width/16//page.width/8
        color: Material.primary
        border.width: dp(2)
        border.color: Material.foreground
        opacity: 0.65
        radius: 12.5
    }



    Rectangle {
        id: otherRect
        anchors.top: titleBanner.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: dp(5) //dp(25)
        anchors.bottomMargin:  page.height/2 //page.height/10
        anchors.leftMargin: page.width/16//page.width/8
        anchors.rightMargin: page.width/16//page.width/8
        color: Material.primary
        border.width: dp(2) //dp(5)
        border.color: Material.foreground
        opacity: 0.65
        radius: 12.5

    }
    CoatOfArms {
        width: dp(180)//dp(280)
        height: dp(45)//dp(85)
        anchors.horizontalCenter: greenRect.horizontalCenter
        anchors.verticalCenter: greenRect.bottom
    }

    MouseArea {
        id: defaultHitZone
        anchors.fill: parent
        onClicked: {
            nullPlayerContainer.forceActiveFocus();
        }
        enabled: !isTVOS
    }

    //top videos
    GridLayout
    {
        //top video players
        anchors.fill: otherRect
        anchors.margins: dp(25)
        columnSpacing: dp(25)
        rowSpacing: dp(15)
        columns: 3
        rows: 2
        flow: page.width >= page.height ? GridLayout.LeftToRight : GridLayout.TopToBottom;
        PlayerContainer {
            id: leftPlayerContainer //top left player

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: leftPlayerContainer.height
            Layout.preferredWidth: leftPlayerContainer.width

            onActiveFocusChanged: {
                if (activeFocus) {
                   console.log(title)
                    Analytics.showScreen(title);

                }
            }
            KeyNavigation.up: {
                if (fullscreen) return leftPlayerContainer;
                else {
                    console.log(" KeyNavigation.up: was fired!..this means, Gpad is converted :)");
                    if (isLandscape) return rightPlayerContainer;
                     else return leftPlayerContainer;
                }
            }
            KeyNavigation.down: {
                if (fullscreen) return bottomMiddlePlayerContainer;
                else {
                     console.log(" KeyNavigation.down: was fired!..this means, Gpad is converted :)");
                    if (isLandscape) return rightPlayerContainer;
                    else return rightPlayerContainer;
                }
            }
            KeyNavigation.left: {
                if (fullscreen) return bottomMiddlePlayerContainer;
                else {
                    if (isLandscape) return bottomMiddlePlayerContainer;
                    else  return bottomMiddlePlayerContainer;
                }
            }
            KeyNavigation.right: {
                console.log("KeyNavigation.right event occured");
                if (isLandscape)  return bottomMiddlePlayerContainer;
                else return bottomMiddlePlayerContainer//nullPlayerContainer;
            }
        }

        PlayerContainer {
            id: bottomMiddlePlayerContainer //top right video
            //changing the video properties
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: leftPlayerContainer.height
            Layout.preferredWidth: leftPlayerContainer.width

            onActiveFocusChanged: {
                if (activeFocus) {
//                    console.log(title)
                    Analytics.showScreen(title);
                }
            }
            KeyNavigation.up: {
                if (fullscreen) return nullPlayerContainer;
                else {
                    if (isLandscape) return bottomRightPlayerContainer;
                     else return bottomRightPlayerContainer//leftPlayerContainer;
                }
            }
            KeyNavigation.down: {
                if (fullscreen) return rightPlayerContainer;
                else {
                    if (isLandscape) return bottomRightPlayerContainer;
                    else return rightPlayerContainer;
                }
            }
            KeyNavigation.left: {
                //if (fullscreen) return leftPlayerContainer;
                //else {
                  //  if (isLandscape) return leftPlayerContainer;
                    //else  return rightPlayerContainer;
                }
            }
            KeyNavigation.right: {
               // if (isLandscape)  return leftPlayerContainer;
                //else return nullPlayerContainer;
            }
           // axisLeftX: isLandscape ? gamepad1.axisLeftX : gamepad1.axisLeftY;
            //axisLeftY: isLandscape ? -gamepad1.axisLeftY : -gamepad1.axisLeftX;
        }

//        PlayerContainer {

//            id: bottomLeftPlayerContainer
//          //  title: qsTr("Committee Proceedings");
//            Layout.fillWidth: true
//            Layout.fillHeight: true
////            Layout.preferredHeight: leftPlayerContainer.height
//            onActiveFocusChanged: {
//                if (activeFocus) {
////                    console.log(title)
//                    Analytics.showScreen(title);
//                }
//            }
//            KeyNavigation.up: {
//                if (fullscreen) return leftPlayerContainer;
//                else {
//                    if (isLandscape) return leftPlayerContainer;
//                     else return bottomRightPlayerContainer;
//                }
//            }
//            KeyNavigation.down: {
//                if (fullscreen) return bottomRightPlayerContainer;
//                else {
//                    if (isLandscape) return nullPlayerContainer;
//                    else return rightPlayerContainer;
//                }
//            }
//            KeyNavigation.left: {
//                if (fullscreen) return bottomRightPlayerContainer;
//                else {
//                    if (isLandscape) return bottomRightPlayerContainer;
//                    else  return nullPlayerContainer;
//                }
//            }
//            KeyNavigation.right: {
//                if (isLandscape)  return bottomRightPlayerContainer;
//                else return nullPlayerContainer;
//            }
//            axisLeftX: isLandscape ? gamepad1.axisLeftX : gamepad1.axisLeftY;
//            axisLeftY: isLandscape ? -gamepad1.axisLeftY : -gamepad1.axisLeftX;
//        }

//        PlayerContainer {
//            id: bottomRightPlayerContainer
//            //title: qsTr("Committee Proceedings");
//            Layout.fillWidth: true
//            Layout.fillHeight: true
////            Layout.preferredHeight: leftPlayerContainer.height
//            onActiveFocusChanged: {
//                if (activeFocus) {
////                    console.log(title)
//                    Analytics.showScreen(title);
//                }
//            }
//            KeyNavigation.up: {
//                if (fullscreen) return rightPlayerContainer;
//                else {
//                    if (isLandscape) return rightPlayerContainer;
//                     else return leftPlayerContainer;
//                }
//            }
//            KeyNavigation.down: {
//                if (fullscreen) return rightPlayerContainer;
//                else {
//                    if (isLandscape) return rightPlayerContainer;
//                    else return rightPlayerContainer;
//                }
//            }
//            KeyNavigation.left: {
//                if (fullscreen) return rightPlayerContainer;
//                else {
//                    if (isLandscape) return bottomLeftPlayerContainer;
//                    else  return nullPlayerContainer;
//                }
//            }
//            KeyNavigation.right: {
//                if (isLandscape)  return bottomLeftPlayerContainer;
//                else return nullPlayerContainer;
//            }
//            axisLeftX: isLandscape ? gamepad1.axisLeftX : gamepad1.axisLeftY;
//            axisLeftY: isLandscape ? -gamepad1.axisLeftY : -gamepad1.axisLeftX;
//        }

  //  }

    //bottom videos
    GridLayout
    {
        //bottom video players
        anchors.fill: greenRect
        anchors.margins: dp(25)
        columnSpacing: dp(15)
        rowSpacing: dp(5)
        columns: 3
        rows: 3
        flow: page.width >= page.height ? GridLayout.LeftToRight : GridLayout.TopToBottom;
        PlayerContainer {
            id: rightPlayerContainer //bottom left video
           // title: qsTr("Committee Proceedings");
            Layout.fillWidth: true
            Layout.fillHeight: true
//            Layout.preferredHeight: leftPlayerContainer.height
            onActiveFocusChanged: {
                if (activeFocus) {
//                    console.log(title)
                    Analytics.showScreen(title);
                }
            }
            KeyNavigation.up: {
                if (fullscreen) return rightPlayerContainer;
                else {
                    if (isLandscape) return leftPlayerContainer;
                     else return bottomMiddlePlayerContainer;
                }
            }
            KeyNavigation.down: {
                if (fullscreen) return bottomLeftPlayerContainer;
                else {
                    if (isLandscape) return leftPlayerContainer;
                    else return bottomLeftPlayerContainer;
                }
            }
            KeyNavigation.left: {
                if (fullscreen) return leftPlayerContainer;
                else {
                    if (isLandscape) return bottomRightPlayerContainer;
                    else  return nullPlayerContainer;
                }
            }
            KeyNavigation.right: {
                if (isLandscape)  return bottomLeftPlayerContainer;
                else return nullPlayerContainer;
            }
          //  axisLeftX: isLandscape ? gamepad1.axisLeftX : gamepad1.axisLeftY;
            axisLeftY: isLandscape ? -gamepad1.axisLeftY : -gamepad1.axisLeftX;
        }

        PlayerContainer {
            id: bottomLeftPlayerContainer //bottom middle video
           // title: qsTr("House Proceedings")
            Layout.fillWidth: true
            Layout.fillHeight: true
           // Layout.preferredHeight: leftPlayerContainer.height
            //Layout.preferredWidth: leftPlayerContainer.width //added this to all the play containers nov 22, wanted to see the effect on the layout flexibility
            onActiveFocusChanged: {
                if (activeFocus) {
//                    console.log(title)
                    Analytics.showScreen(title);
                }
            }
            KeyNavigation.up: {
                if (fullscreen) return rightPlayerContainer;
                else {
                    if (isLandscape) return leftPlayerContainer;
                    else return rightPlayerContainer;
                }
            }
            KeyNavigation.down: {
                if (fullscreen) return bottomRightPlayerContainer;
                else {
                    if (isLandscape) return leftPlayerContainer;
                     else return bottomRightPlayerContainer;
                }
            }
            KeyNavigation.left: {
                if (isLandscape)  return rightPlayerContainer;
                else return nullPlayerContainer;
            }
            KeyNavigation.right: {
                if (fullscreen) return bottomRightPlayerContainer;
                else {
                    if (isLandscape) return bottomRightPlayerContainer;
                    else  return bottomRightPlayerContainer;
                }
            }
            axisLeftX: isLandscape ? -gamepad1.axisLeftX : -gamepad1.axisLeftY;
            axisLeftY: isLandscape ? gamepad1.axisLeftY : gamepad1.axisLeftX;
        }
        PlayerContainer {
            id: bottomRightPlayerContainer //bottom right videoplayer
           // title: qsTr("Committee Proceedings");
            Layout.fillWidth: true
            Layout.fillHeight: true
           // Layout.preferredHeight: leftPlayerContainer.height
            //Layout.preferredWidth: leftPlayerContainer.width
            onActiveFocusChanged: {
                if (activeFocus) {
//                    console.log(title)
                    Analytics.showScreen(title);
                }
            }
            KeyNavigation.up: {
                if (fullscreen) return rightPlayerContainer;
                else {
                    if (isLandscape) return bottomMiddlePlayerContainer;
                     else return bottomLeftPlayerContainer;
                }
            }
            KeyNavigation.down: {
                if (fullscreen) return rightPlayerContainer;
                else {
                    if (isLandscape) return bottomMiddlePlayerContainer;
                    else return leftPlayerContainer;
                }
            }
            KeyNavigation.left: {
                if (fullscreen) return bottomLeftPlayerContainer;
                else {
                    if (isLandscape) return bottomLeftPlayerContainer;
                    else  return nullPlayerContainer;
                }
            }
            //leftPlayerContainer //top left player
             // bottomMiddlePlayerContainer //top right video
             // rightPlayerContainer //bottom left video
            //bottomLeftPlayerContainer -bottom middle player
            //bottomRightPlayerContainer //bottom right videoplayer
            KeyNavigation.right: {
                if (isLandscape)  return rightPlayerContainer;
                else return rightPlayerContainer;
            }
            axisLeftX: isLandscape ? gamepad1.axisLeftX : gamepad1.axisLeftY;
            axisLeftY: isLandscape ? -gamepad1.axisLeftY : -gamepad1.axisLeftX;
        }


    }



    Item {
        focus: true
        id: nullPlayerContainer
        onActiveFocusChanged: {
            if (activeFocus) {
               console.log("Home")
                Analytics.showScreen("Home");
            }
        }
        //undo below
       KeyNavigation.up: isLandscape ? nullPlayerContainer : leftPlayerContainer
       KeyNavigation.down: isLandscape ? nullPlayerContainer : rightPlayerContainer
       KeyNavigation.left: isLandscape ? leftPlayerContainer : nullPlayerContainer
       KeyNavigation.right: isLandscape ? bottomMiddlePlayerContainer : nullPlayerContainer
       Keys.onPressed: {
           console.log("StreamsPage Key event: " + event.key.toString(16)); // https://doc.qt.io/qt-5/qt.html#Key-enum
            if (event.key === Qt.Key_Back ||
                event.key === Qt.Key_Escape ||
                (isTVOS && event.key === Qt.Key_Menu)) {
                Qt.quit();
            }
        }
    }

    Connections {
          target: gamepad1
          function onUp() {
             // if (leftPlayerContainer.fullscreen || rightPlayerContainer.fullscreen) return;
          console.log("StreamsPage: Gamepad Up pressed!")
          //    if (isLandscape) nullPlayerContainer.forceActiveFocus();
            //  else leftPlayerContainer.forceActiveFocus();
          }
          function onDown() {
             // if (leftPlayerContainer.fullscreen || rightPlayerContainer.fullscreen) return;
           // console.log("StreamsPage: Gamepad Down pressed!")
           //   if (isLandscape) nullPlayerContainer.forceActiveFocus();
            //  else rightPlayerContainer.forceActiveFocus();
          }
          function onLeft() {
             // if (leftPlayerContainer.fullscreen || rightPlayerContainer.fullscreen) return;
         //  console.log("StreamsPage: Gamepad Left pressed!")
            // if (isLandscape) leftPlayerContainer.forceActiveFocus();
             // else nullPlayerContainer.forceActiveFocus();
          }
          function onRight() {
              //if (leftPlayerContainer.fullscreen || rightPlayerContainer.fullscreen) return;
         //  console.log("StreamsPage: Gamepad Right pressed!")
            //  if (isLandscape) rightPlayerContainer.forceActiveFocus();
             // else nullPlayerContainer.forceActiveFocus();
          }
          function onA() {
              if (leftPlayerContainer.fullscreen || rightPlayerContainer.fullscreen) return;
             console.log("StreamsPage: Gamepad A pressed!");
              if (leftPlayerContainer.focus) leftPlayerContainer.fullscreen = true;
              else if (rightPlayerContainer.focus) rightPlayerContainer.fullscreen = true;
          }
          function onB() {
             console.log("StreamsPage: Gamepad B pressed!");
              if (leftPlayerContainer.fullscreen) leftPlayerContainer.fullscreen = false;
              else if (rightPlayerContainer.fullscreen) rightPlayerContainer.fullscreen = false;
              else if (leftPlayerContainer.focus || rightPlayerContainer.focus) nullPlayerContainer.forceActiveFocus();
              else Qt.quit();
          }
          function onX() {
              if (leftPlayerContainer.fullscreen || rightPlayerContainer.fullscreen) return;
  //            console.log("StreamsPage: X pressed!");
          }
      }

}


