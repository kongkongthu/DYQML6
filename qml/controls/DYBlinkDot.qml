import QtQuick 2.15
import QtQuick.Controls 2.15

DObject {
    id: dyBlinkDot

    property color fromColor
    property color toColor
    property double fromScale
    property int period
    property bool reverse


    Rectangle {
        width: dyBlinkDot.width
        height: dyBlinkDot.height
        color: fromColor
        anchors.horizontalCenter: dyBlinkDot.horizontalCenter
        anchors.verticalCenter: dyBlinkDot.verticalCenter
        radius: Math.max(dyBlinkDot.width, dyBlinkDot.height) / 2
        scale: reverse ? fromScale : 1


        NumberAnimation on scale {
            from: reverse ? 1 : fromScale
            to: reverse ? fromScale : 1
            duration: period
            running: true
            loops: Animation.Infinite
        }

        ColorAnimation on color {
            from:fromColor
            to: toColor
            duration: period
            running: true
            loops: Animation.Infinite
        }
    }
}
