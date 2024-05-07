import QtQuick 2.15
import QtQuick.Controls 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dySlider
    property string name
    property int fontSize
    property int decimalNum
    property real max
    property real min
    property real defaultValue
    property bool showValue
    property int valueWidth

    Text {
        id: nameStr
        text: qsTr(dySlider.name ? dySlider.name+":" : "")
        width: implicitWidth
        height: parent.height
        anchors.left: parent.left
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: dySlider.name ? true : false
        font.pixelSize: fontSize
        color: dySlider.enabled ? frontEnd.colorSpace.primaryFontColor :
                                  Qt.color(frontEnd.colorSpace.primaryFontColor).darker(1.3)
    }

    Rectangle{
        id: inputRect
        anchors.right: parent.right
        width: showValue ? valueWidth : 0
        height: parent.height
        radius: 3
        color: dySlider.enabled ?
                   frontEnd.colorSpace.lighterBackgroundColor :
                   frontEnd.colorSpace.primaryDisableColor
        visible: showValue
        TextInput{
            id: inputer
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: dySlider.enabled ? frontEnd.colorSpace.primaryFontColor :
                        Qt.color(frontEnd.colorSpace.primaryFontColor).darker(1.3)
            font.pixelSize: fontSize
            text: defaultValue
            validator: DoubleValidator{
                decimals: decimalNum
                bottom: min
                top: max
            }
        }
    }

    Slider {
        id: slider
        anchors.left: nameStr.right
        anchors.right: inputRect.left
        anchors.verticalCenter: parent.verticalCenter
        from: min
        to: max
        value: defaultValue
        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: slider.availableWidth
            height: implicitHeight
            radius: 2
            color: dySlider.enabled ? frontEnd.colorSpace.baseBorderColor :
                                      frontEnd.colorSpace.lighterBorderColor

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: dySlider.enabled ?
                           frontEnd.colorSpace.brandColor :
                           frontEnd.colorSpace.primaryDisableColor
            }
        }
        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: dySlider.height - 2 * slider.topPadding
            implicitHeight: implicitWidth
            radius: implicitWidth / 2
            color: slider.pressed ?  frontEnd.colorSpace.baseBorderColor :
                                    frontEnd.colorSpace.lighterBorderColor
            border.color: frontEnd.colorSpace.baseBorderColor
            DYToolTip{
                id: valueTip
                text: slider.value
            }
        }
    }

    Component.onCompleted: {
        formFieldInfo();
    }

    Connections{
        target: slider
        function onMoved(){
            inputer.text = slider.value.toFixed(decimalNum);
            formFieldInfo();
            procAndEmitDSignal();
            valueTip.show(slider.value.toFixed(decimalNum), 1000);
        }
    }

    Connections{
        target: inputer
        function onTextEdited(){
            slider.value = inputer.text;
            formFieldInfo();
            procAndEmitDSignal();
        }
        function onFocusChanged(){
            if(inputer.focus)
                inputRect.color = Qt.lighter(inputRect.color, 1.3);
            else
                inputRect.color = Qt.darker(inputRect.color, 1.3);
        }
    }

    function formFieldInfo(){
        fieldInfo[dSignal["sigId"]] = slider.value.toFixed(decimalNum);
    }

    function procAndEmitDSignal(){
        dSignal["subInfo"] = {
            "value": Number(inputer.text)
        };
        EmitSignal.emitSignal(dSignal);
    }
}
