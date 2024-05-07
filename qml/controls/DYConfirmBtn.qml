import QtQuick 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dyConfirmBtn
    width: 100
    height: 60
    radius: 5
    property string name: "Confirm"
    property int fontSize: 18
    property color disableColor
    property color btnColor
    property color fontColor
    property color _initColor

    Text {
        id: btnName
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: dyConfirmBtn.name
        font.pixelSize: dyConfirmBtn.fontSize
        color: fontColor
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if(dyConfirmBtn.enabled){
                dyConfirmBtn.color = dyConfirmBtn.color.lighter(1.2);
            }
        }
        onExited: {
            if(dyConfirmBtn.enabled)
                dyConfirmBtn.color = dyConfirmBtn.color.darker(1.2);
        }
        onPressed: {
            if(dyConfirmBtn.enabled)
                dyConfirmBtn.color = dyConfirmBtn.color.lighter(1.2);
        }
        onReleased: {
            frontEnd.sigTriggerBackEnd(dSignal);
            dyConfirmBtn.enabled = false;
            let disableAllConfirmBtnSignal = {
                "sigId": "SET-CONFIRM-BUTTON-DISABLE",
                "destCode": "010",
            }
            EmitSignal.emitSignal(disableAllConfirmBtnSignal);
        }
    }

    Component.onCompleted: {
        dyConfirmBtn.color = dyConfirmBtn.btnColor
        _initColor = dyConfirmBtn.btnColor;
        dyConfirmBtn.enabled = false;
    }

    onEnabledChanged: {
        if(dyConfirmBtn.enabled){
            dyConfirmBtn.color = _initColor;
            btnName.color = btnName.color.lighter(1.2);
        }
        else{
            dyConfirmBtn.color = dyConfirmBtn.disableColor;
            btnName.color = btnName.color.darker(1.2);
        }
    }

    onBtnColorChanged: {
        _initColor = dyConfirmBtn.btnColor;
        if(dyConfirmBtn.enabled)
            dyConfirmBtn.color = _initColor;
    }

    onDisableColorChanged: {
        if(!dyConfirmBtn.enabled)
            dyConfirmBtn.color = disableColor;
    }

    Connections {
        target: frontEnd
        function onSigTriggerConfirm(dSignalIn){
            if(dSignalIn.sigId){
                if(dSignalIn.sigId === "SET-CONFIRM-BUTTON-DISABLE")
                    dyConfirmBtn.enabled = false;
                else{
                    dyConfirmBtn.dSignal = dSignalIn;
                    dyConfirmBtn.enabled = true;
                }
            }
            else
                dyConfirmBtn.enabled = false;
        }
        function onSigTriggerGUI(dSignalIn){
            if(dSignalIn.sigId === "SET-CONFIRM-BUTTON-DISABLE")
                dyConfirmBtn.enabled = false;
        }
    }
}
