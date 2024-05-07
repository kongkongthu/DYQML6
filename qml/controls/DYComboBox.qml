import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Templates 2.15 as T
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dyComboBox
    property int fontSize
    property color fontColor
    property color bkColor
    property color disableColor
    property var dSignal:({})
    property var attachedValue: []
    property var itemList: []
    property string name
    property int lastIndex
    property int defaultIndex: 0

    Text{
        id: comboName
        text: dyComboBox.name ? dyComboBox.name+":" : ""
        font.pixelSize: dyComboBox.fontSize
        font.family: frontEnd.fontFamily
        color: dyComboBox.enabled ? fontColor : fontColor.darker(1.3)
        width: implicitWidth
        height: dyComboBox.height
        anchors.left: parent.left
        verticalAlignment: Text.AlignVCenter
    }

    T.ComboBox{
        id: comboBox
        model: dyComboBox.itemList
        font.pixelSize: dyComboBox.fontSize
        font.family: frontEnd.fontFamily
//        width: dyComboBox.width-comboName.width-dyComboBox.border.width*2
        height: dyComboBox.height - 4 * dyComboBox.border.width
        anchors.left: comboName.right
        anchors.right: parent.right
        anchors.rightMargin: dyComboBox.border.width*2
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: 3
        rightPadding: 3
        hoverEnabled: true

        // 弹出框每行的委托
        delegate: ItemDelegate{
            width: comboBox.width
            height: comboBox.height
            contentItem: Rectangle{
                anchors.fill: parent
                color: hovered ? frontEnd.colorSpace.lightBackgroundColor
                                  : frontEnd.colorSpace.backgroundColor
                Text {
                    text: modelData
                    color: fontColor
                    height: parent.height
                    font.pixelSize: dyComboBox.fontSize
                    font.family: frontEnd.fontFamily
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                }
            }

            palette.text: comboBox.palette.text
            palette.highlightedText: comboBox.palette.highlightedText
            highlighted: comboBox.highlightedIndex === index
            font.weight: comboBox.currentIndex
                === index ? Font.DemiBold : Font.Normal
            hoverEnabled: comboBox.hoverEnabled
        }

        //右侧下拉箭头
        indicator: Canvas {
            id: canvas
            x: comboBox.width - canvas.width - comboBox.rightPadding * 2
            y: comboBox.topPadding + (comboBox.availableHeight - height) / 2
            width: 10;
            height: 6;
            contextType: "2d"
            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineWidth = 2;
                context.lineTo(width / 2, height*0.8);
                context.lineTo(width, 0);
                context.strokeStyle = comboBox.pressed ? "#EEEFF7" : "#999999";
                context.stroke();
            }
        }

        // ComboBox的文字位置样式
        contentItem: T.TextField {
            leftPadding: !comboBox.mirrored ? 12 : comboBox.editable && activeFocus ? 3 : 1;
            rightPadding: comboBox.mirrored ? 12 : comboBox.editable && activeFocus ? 3 : 1;
            topPadding: 6 - comboBox.padding;
            bottomPadding: 6 - comboBox.padding;

            text: comboBox.editable ? comboBox.editText : comboBox.displayText;

            enabled: comboBox.editable;
            autoScroll: comboBox.editable;
            readOnly: comboBox.down;
            inputMethodHints: comboBox.inputMethodHints;
            validator: comboBox.validator;

            font: comboBox.font;
            color: dyComboBox.enabled ?
                       (comboBox.focus ?
                            fontColor.lighter(1.3) : fontColor) :
                                fontColor.darker(1.3)
            selectionColor: comboBox.palette.highlight;
            selectedTextColor: comboBox.palette.highlightedText;
            verticalAlignment: Text.AlignVCenter;
            renderType: Text.NativeRendering;

            background: Rectangle {
                layer.enabled: true
                visible: comboBox.enabled && comboBox.editable && !comboBox.flat;
                border.width: parent && parent.activeFocus ? 2 : 1;
                border.color: parent && parent.activeFocus ? comboBox.palette.highlight : comboBox.palette.button;
                color: comboBox.palette.base;
            }
        }

        // ComboBox 的背景样式
        background: Rectangle {
            layer.enabled: true
            radius: 3
            color: comboBox.enabled ?  bkColor : disableColor
            border.color: comboBox.enabled ?
                            (comboBox.focus ? frontEnd.colorSpace.brandColor : frontEnd.colorSpace.baseBorderColor)
                            : frontEnd.colorSpace.primaryColor;
            border.width: !comboBox.editable && comboBox.visualFocus ? 2 : 1;
            visible: !comboBox.flat || comboBox.down;
        }

        // 弹出窗口样式
        popup: T.Popup {
            y: comboBox.height;
            width: comboBox.width;
            height: comboBox.model.length * comboBox.height
            topMargin: 3;
            bottomMargin: 3;

            contentItem: ListView {
                // 防止显示过界
                clip: true;
                //禁止滑动
                // interactive: false;
                //禁用橡皮筋效果
                boundsBehavior: Flickable.StopAtBounds;
                implicitHeight: contentHeight;
                model: comboBox.delegateModel;
                currentIndex: comboBox.highlightedIndex;
                highlightMoveDuration: 0;

                Rectangle {
                    z: 10;
                    width: parent.width;
                    height: parent.height;
                    color: "transparent";
                    layer.enabled: true
                    border.color: frontEnd.colorSpace.lighterBorderColor
    //                border.color: comboBox.palette.mid;
                }

                T.ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
        Component.onCompleted: {
            dyComboBox.lastIndex = comboBox.currentIndex;
            formFieldInfo();
        }

        onFocusChanged: {
            if(focus){
                sendCrtDSignal();
            }
        }

        onActivated: {
            sendCrtDSignal();
        }

        function sendCrtDSignal(){
            formFieldInfo();
            dSignal["subInfo"] = {
                "index": comboBox.currentIndex,
                "item": comboBox.currentValue,
                "attachedvalue": 
                    dyComboBox.attachedValue[comboBox.currentIndex]
                    ? dyComboBox.attachedValue[comboBox.currentIndex]
                    : "noValue",
            }
            EmitSignal.emitSignal(dSignal);
        }

        function formFieldInfo(){
            fieldInfo[dSignal["sigId"]] = comboBox.currentText
        }
    }
}
