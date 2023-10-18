import QtQuick 2.0
import QtGamepad 1.0

Gamepad {
    id: gamepad1

    signal left
    signal right
    signal up
    signal down

    signal a;
    signal b;
    signal x;
    signal y;

    onAxisLeftYChanged: {
        if (axisLeftY > 0.75) down();
        else if (axisLeftY < -0.75) up();
    }

    onAxisLeftXChanged: {
        if (axisLeftX > 0.75) right();
        else if (axisLeftX < -0.75) left();
    }

    onButtonLeftChanged: {
        if(buttonLeft) left();
    }

    onButtonRightChanged: {
        if(buttonRight) right();
    }

    onButtonUpChanged: {
        if(buttonUp) up();
    }

    onButtonDownChanged: {
        if(buttonDown) down();
    }

    onButtonAChanged: {
        if (buttonA) a();
    }

    onButtonBChanged: {
        if (buttonB) b();
    }

    onButtonXChanged: {
        if (buttonX) x();
    }

    onButtonYChanged: {
        if (buttonY) y();
    }

    deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
}

//import QtQuick 2.0
//import QtGamepad 1.0

//Gamepad {
//    id: gamepad1

//    signal left
//    signal right
//    signal up
//    signal down

//    signal a;
//    signal b;
//    signal x;
//    signal y;

//    onAxisLeftYChanged: {
//         console.log("debug initiated onAxisLeftYChanged action!");
//      // if (axisLeftY > 0.75) down();
//       //else if (axisLeftY < -0.75) up();

//        //if (axisLeftY > 0.75) up();
//      //  else if (axisLeftY < -0.75) down();
//    }

//    onAxisLeftXChanged: {
//        console.log("debug initiated onAxisLeftXChanged action!");
//        if (axisLeftX > 0.75){
//            console.log("bouta exe axisLeftX > 0.75) onAxisLeftXChanged action!");
//         //   right();
//        }
//        else if (axisLeftX < -0.75) {
//        console.log("bouta exe axisLeftX < -0.75 onAxisLeftXChanged action!");
//        //left();
//        }
//    }

//    onButtonLeftChanged: {
//        console.log("initiated left action!")
//        if(buttonLeft) left();
//    }

//    onButtonRightChanged: {
//        console.log("initiated onButtonRightChanged action!");
//        if(buttonRight) right();
//    }

//    onButtonUpChanged: {
//         console.log("initiated onButtonUpChanged action!");
//        if(buttonUp) up();
//    }

//    onButtonDownChanged: {
//        if(buttonDown) down();
//    }

//    onButtonAChanged: {
//        if (buttonA) a();
//    }

//    onButtonBChanged: {
//        if (buttonB) b();
//    }

//    onButtonXChanged: {
//        if (buttonX) x();
//    }

//    onButtonYChanged: {
//        if (buttonY) y();
//    }

//    deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1


//}


