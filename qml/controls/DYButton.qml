import QtQuick 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: dyBtn
//    color: frontEnd.colorSpace.primaryColor
//    border.color: frontEnd.colorSpace.baseBorderColor
    dyType: "submit"
    property bool holdStatus
    property string name
    property int nameX
    property string imagePath
    property int imageX
    property int fontSize
    property color fontColor
    property bool defaultHold
    property color disableColor
    property color _tmpColor
    property var _textObj
    property var _imageObj
    property bool _hold
    property var _unLockDSignal
    property bool _loaded: false
    signal sigSubmit(var dSignal)

    Component {
        id: btnImageComp
        Image{
            width: Math.min(dyBtn.width, dyBtn.height) * 0.8
            height: Math.min(dyBtn.width, dyBtn.height) * 0.8
            source: "file:"+imagePath
        }
    }


    Component {
        id: btnNameComp
        Text{
            text: dyBtn.name
            color: dyBtn.enabled ? dyBtn.fontColor : dyBtn.fontColor.darker(1.3)
            font.pixelSize: fontSize
            font.family: frontEnd.fontFamily
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: implicitWidth
        }
    }

    Component.onCompleted: {
        if(fontColor===frontEnd.undefinedColor)
            fontColor = frontEnd.colorSpace.primaryFontColor;
        if(imagePath)
            _imageObj = btnImageComp.createObject(dyBtn);
        if(name)
            _textObj = btnNameComp.createObject(dyBtn);
        arrangeSubObj();
        initStatus();
        _loaded = true;
    }

    function arrangeSubObj(){
        if(imagePath && !name)
            arrangeOnlyImage();
        else if(!imagePath && name)
            arrangeOnlyText();
        else if(imagePath && name)
            arrangeBothImageAndText();
    }

    function arrangeOnlyImage(){
        _imageObj.anchors.horizontalCenter = dyBtn.horizontalCenter;
        _imageObj.anchors.verticalCenter = dyBtn.verticalCenter;
    }

    function arrangeOnlyText(){
        _textObj.anchors.horizontalCenter = dyBtn.horizontalCenter;
        _textObj.anchors.verticalCenter = dyBtn.verticalCenter;
    }

    function arrangeBothImageAndText(){
        _imageObj.anchors.verticalCenter = dyBtn.verticalCenter;
        _imageObj.anchors.left = dyBtn.left;
        _imageObj.anchors.leftMargin = dyBtn.imageX;
        _textObj.anchors.verticalCenter = dyBtn.verticalCenter;
        _textObj.anchors.left = dyBtn.left;
        _textObj.anchors.leftMargin = dyBtn.nameX;
    }

    function initStatus(){
        _tmpColor = dyBtn.color;
        _hold = defaultHold;
        if(holdStatus){
            _unLockDSignal = JSON.parse(JSON.stringify(dSignal));
            _unLockDSignal.sigId = _unLockDSignal.sigId + "-off";
        }
        if(holdStatus && _hold){
            if(enabled)
                dyBtn.color = _tmpColor.lighter(1.7);
            else
                dyBtn.color = disableColor.lighter(1.7);
        }else{
            if(enabled)
                dyBtn.color = _tmpColor;
            else
                dyBtn.color = disableColor;
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onPressed: {
            dyBtn.color = _tmpColor.lighter(1.7);
            sigSubmit(dyBtn.dSignal);
            if(holdStatus)
                emitSignalByHold();
            else{
                EmitSignal.emitSignal(dSignal);
            }

        }
        onEntered: {
            if(dyBtn.enabled){
                if(!holdStatus || !_hold){
                    dyBtn.color = _tmpColor.lighter(1.2);
                    createToolTipObj();
                }
            }
        }
        onExited: {
            if(dyBtn.enabled){
                if(!holdStatus || !_hold){
                    dyBtn.color = dyBtn._tmpColor;
                    destroyToolTipObj();
                }
            }
        }
        onReleased: {
            if(!holdStatus || !_hold)
                dyBtn.color = _tmpColor.lighter(1.2);
        }
    }

    onEnabledChanged: {
        if(!dyBtn.enabled && dyBtn._loaded)
            dyBtn.color = dyBtn.disableColor;
        else if(dyBtn.enabled && dyBtn._loaded){
            dyBtn.color = dyBtn._tmpColor;
        }
    }


    function emitSignalByHold(){
        if(_hold){
            dyBtn.color = _tmpColor.lighter(1.2);
            EmitSignal.emitSignal(_unLockDSignal);
        }
        else{
            dyBtn.color = _tmpColor.lighter(1.7);
            EmitSignal.emitSignal(dSignal);
        }
        _hold = !_hold;
    }
}
