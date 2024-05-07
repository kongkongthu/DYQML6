import QtQuick 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dyTextInput
    // 加入以下属性fontSize、fontColor、name、type
    property int fontSize
    property color fontColor
    property color bkColor
    property color disableColor
    property color inputBorderColor
    property int inputBorderWidth
    property int inputBorderRadius
    property string name
    property bool isPassword
    property bool isNumber
    property int decimalNum
    property double minNum
    property double maxNum
    property string textHAlignment
    property bool wrap


    Text {
        id: text
        text: name ? name + ":" : ""
        font.pixelSize: fontSize
        font.family: frontEnd.fontFamily
        color: dyTextInput.enabled ? fontColor : fontColor.darker(1.3)
        width: text.implicitWidth
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle{
        id: inputBorder
        height: parent.height
        color: dyTextInput.enabled ?
                   (input.focus ? bkColor.lighter(1.5) : bkColor) :
                   disableColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: text.right
        anchors.right: parent.right
        border.color: dyTextInput.enabled ?
                            (input.focus ? frontEnd.colorSpace.brandColor :
                            inputBorderColor) :
                            inputBorderColor
        border.width: inputBorderWidth
        radius: inputBorderRadius
        clip: true

        TextInput {
            id: input
            font.pixelSize: fontSize
            font.family: frontEnd.fontFamily
            color: dyTextInput.enabled ? fontColor : fontColor.darker(1.3)
            anchors.fill: inputBorder
            leftPadding: 3
            rightPadding: 3
            verticalAlignment: Text.AlignVCenter
            selectByMouse: true
            echoMode: isPassword ? TextInput.Password : TextInput.Normal
            wrapMode: dyTextInput.wrap ? TextInput.Wrap : TextInput.NoWrap
        }
    }

    Component{
        id: validatorComp
        DoubleValidator{
            decimals: dyTextInput.decimalNum
            bottom: minNum
            top: maxNum
        }
    }

    Component.onCompleted: {
        if(isNumber){
            input.validator = validatorComp.createObject();
            input.text = (minNum + maxNum) / 2;
        }
        switch (textHAlignment){
        case "left":
            input.horizontalAlignment = Text.AlignLeft;
            break;
        case "center":
            input.horizontalAlignment = Text.AlignHCenter;
            break;
        case "right":
            input.horizontalAlignment = Text.AlignRight;
            break;
        }
        formFieldInfo();
    }

    Connections {
        target: input
        function onTextChanged(){
            if(isNumber)
                procNumberMinMax();
            formFieldInfo();
            emitInputStatus();
        }
    }


    function procNumberMinMax(){
        if(Number(input.text) < minNum)
            input.text = minNum;
        else if(Number(input.text) > maxNum)
            input.text = maxNum;
    }

    function emitInputStatus(){
        if(!dSignal["subInfo"])
            dSignal["subInfo"] = {};
        if(isNumber)
            dSignal["subInfo"]["text"] = Number(input.text);
        else
            dSignal["subInfo"]["text"] = input.text;
        EmitSignal.emitSignal(dSignal);
    }

    function formFieldInfo(){
        fieldInfo[dSignal["sigId"]] = input.text;
    }
}
