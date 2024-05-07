import QtQuick 2.15
DObject {
    id: dyText
    color: "#00000000"
    property string text
    property int fontSize: 18
    property color fontColor
    property bool fontBold
    property string textHAlignment
    property string textVAlignment

    Text {
        id: innerText
        anchors.fill: parent
        text: qsTr(dyText.text)
        color: fontColor
        font.pixelSize: fontSize
        font.bold: fontBold
        font.family: frontEnd.fontFamily
    }

    Component.onCompleted: {
        _initTextHAlignment();
        _initTextVAlignment();
    }

    function _initTextHAlignment(){
        switch(textHAlignment){
        case "left":
            innerText.horizontalAlignment = Text.AlignLeft;
            break;
        case "right":
            innerText.horizontalAlignment = Text.AlignRight;
            break;
        case "center":
            innerText.horizontalAlignment = Text.AlignHCenter;
            break;
        default:
            innerText.horizontalAlignment = Text.AlignLeft;
            break;
        }
    }

    function _initTextVAlignment(){
        switch(textVAlignment){
        case "top":
            innerText.verticalAlignment = Text.AlignTop;
            break;
        case "bottom":
            innerText.verticalAlignment = Text.AlignBottom;
            break;
        case "center":
            innerText.verticalAlignment = Text.AlignVCenter;
            break;
        default:
            innerText.verticalAlignment = Text.AlignTop;
            break;
        }
    }
}
