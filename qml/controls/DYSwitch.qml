import QtQuick 2.15
import QtQuick.Controls 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dySwitch
    property var onDSignal:({})
    property var offDSignal:({})
    property string name
    property bool defaultValue: false
    property bool lastCheckdStatus: false
    property int fontSize: 14
    property color fontColor
    property color onColor
    property color offColor
    property color dotColor
    property string onText: "On"
    property string offText: "Off"
    property string sigId
    
    Switch {
        id: control
        width: parent.width
        height: parent.height
        checked: dySwitch.defaultValue
        contentItem: Text {
            id: controlName
            text: dySwitch.name ? dySwitch.name + ":" : ""
            width: dySwitch.name ? controlName.implicitWidth : 0
            height: parent.height
            font.pixelSize: dySwitch.fontSize
            color: dySwitch.fontColor
            font.family: frontEnd.fontFamily
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            opacity: enabled ? 1.0 : 0.5
        }
        indicator: Rectangle{
            id: switchRect
            width: (parent.height - 6) * 2
            height: parent.height - 6
            radius: switchRect.height / 2
            color: control.enabled ?
                    (control.checked ? onColor : offColor) :
                    (control.checked ? onColor.lighter(1.5) : offColor.lighter(1.5))
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            Text{
                id: switchText
                text: control.checked ? dySwitch.onText : dySwitch.offText
                font.pixelSize: dySwitch.fontSize -2
                color: dySwitch.fontColor
                font.family: frontEnd.fontFamily
                height: parent.height
                verticalAlignment: Text.AlignVCenter

            }
            Rectangle {
                id: dot
                x: control.checked ? parent.width - width -2  : 2
                width: parent.height - 4
                height: width
                radius: width / 2
                color: dotColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Component.onCompleted: {
        try{
            sigId = dSignal["sigId"];
        }catch(err){}
        lastCheckdStatus = dySwitch.defaultValue;
        formFieldInfo();
        verifyTextPos();
    }

    Connections{
        target: control
        function onCheckedChanged() {
            verifyTextPos();
            formFieldInfo();
            emitSwitchStatus();
        }
    }

    function emitSwitchStatus(){
        if(sigId){
            if(control.checked)
                dSignal["sigId"] = sigId + "-ON";
            else
                dSignal["sigId"] = sigId + "-OFF";
            EmitSignal.emitSignal(dSignal);
        }
    }

    function verifyTextPos(){
        if(control.checked){
            switchText.anchors.right = undefined
            switchText.anchors.left = switchRect.left
            switchText.anchors.leftMargin = 5
        }
        else{
            switchText.anchors.left = undefined
            switchText.anchors.right = switchRect.right
            switchText.anchors.rightMargin = 5
        }
    }

    function formFieldInfo(){
        if(dSignal)
            if(dSignal["sigId"])
                fieldInfo[dSignal["sigId"]] = control.checked;
    }
}
