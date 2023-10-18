import QtQuick 2.0
import QtGamepad 1.0

Item {

    signal left
    signal right
    signal up
    signal down

    signal a;
    signal b;
    signal x;
    signal y;

    property alias axisLeftX : gamepad1.axisLeftX
    property alias axisLeftY: gamepad1.axisLeftY
    property alias deviceId: gamepad1.deviceId

    Gamepad {
        id: gamepad1

        onAxisLeftYChanged: {
            if (axisLeftY > 0.75) down();
            else if (axisLeftY < -0.75) up();
        }

        onAxisLeftXChanged: {
            if (axisLeftX > 0.75) right();
            else if (axisLeftX < -0.75) left();
        }

        deviceId: GamepadManager.connectedGamepads.length > 0 ? GamepadManager.connectedGamepads[0] : -1
    }

    // This "kinda" turns our gamepad into a keyboard, but doesn't work on TVOS
    GamepadKeyNavigation {

       // id: gamepadKeyNavigation
        gamepad: gamepad1
        active: true

    }

}
