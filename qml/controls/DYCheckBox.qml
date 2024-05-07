import QtQuick 2.15
import QtQuick.Controls
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dyCheckBox
    property string name
    property color ctrlColor
    property color fontColor
    property int fontSize
    property bool checked
    property string sigId
    property var unCheckedByList: []

    CheckBox {
        id: control
        text: qsTr(dyCheckBox.name)
        checked: dyCheckBox.checked
        font.family: frontEnd.fontFamily
        font.pixelSize: fontSize
        anchors.fill: parent

        indicator: Rectangle {
            implicitWidth: control.height - control.leftPadding
            implicitHeight: control.height - control.leftPadding
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: 3
            border.color: ctrlColor//control.down ? "#17a81a" : "#21be2b"

            Rectangle {
                width: parent.width * 3 / 5
                height: parent.height * 3 / 5
                anchors.centerIn: parent
                radius: 2
                color: ctrlColor
                visible: control.checked
            }
        }

        contentItem: Text {
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: fontColor
            verticalAlignment: Text.AlignVCenter
            leftPadding: control.indicator.width + control.spacing
        }
    }

    Connections{
        target: control
        function onReleased(){
            if(sigId){
                if(control.checked)
                    dSignal["sigId"] = sigId + "-ON"
                else
                    dSignal["sigId"] = sigId + "-OFF"
                EmitSignal.emitSignal(dSignal)
            }
        }
    }


    Component.onCompleted: {
        sigId = dSignal["sigId"];
    }


    Connections{
        target: frontEnd
        function onSigTriggerFrontEnd(dSignal){
            if(unCheckedByList.includes(dSignal["sigId"]))
                control.checked = false;
        }
    }
}
