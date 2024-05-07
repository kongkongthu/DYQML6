import QtQuick 2.15
import QtQuick.Controls 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dyRadioButton
    property string name
    property color disableColor
    property color radioColor
    property color fontColor
    property int fontSize
    property bool checked
    property var unCheckedByList: []

    RadioButton {
        id: radioBtn
        anchors.fill: parent
        text: name
        checked: dyRadioButton.checked


        indicator: Rectangle {
            width: radioBtn.height - radioBtn.leftPadding
            height: radioBtn.height - radioBtn.leftPadding///implicitWidth
            x: radioBtn.leftPadding
            y: parent.height / 2 - height / 2
            radius: width / 2
            border.color: dyRadioButton.enabled ? radioColor : disableColor

            Rectangle {
                width: parent.width * 3 / 5
                height: parent.height * 3 / 5
                anchors.centerIn: parent
                radius: width / 2
                color: dyRadioButton.enabled ? radioColor : disableColor
                visible: radioBtn.checked
            }
        }

        contentItem: Text {
            text: radioBtn.text
            font.pixelSize: dyRadioButton.fontSize
            font.family: frontEnd.fontFamily
            color: dyRadioButton.enabled ? fontColor : fontColor.darker(1.3)
            verticalAlignment: Text.AlignVCenter
            leftPadding: radioBtn.indicator.width + radioBtn.spacing
        }
    }

    function postProcStatusOnSignal(dSignal){
        for(let i=0; i<unCheckedByList.length; i++){
            if(dSignal["sigId"]===unCheckedByList[i]){
                radioBtn.checked = false;
                formFieldInfo();
            }
        }
    }

    Connections {
        target: radioBtn
        function onReleased(){
            formFieldInfo();
            EmitSignal.emitSignal(dSignal);
        }
    }

    Component.onCompleted: {
        formFieldInfo();
    }

    function formFieldInfo(){
        fieldInfo[dSignal["sigId"]] = radioBtn.checked;
    }
}
