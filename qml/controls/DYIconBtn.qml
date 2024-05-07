import QtQuick 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DControllerBase {
    id: iconBtn
    property int iconWidth
    property int iconHeight
    property bool defaultStatus
    property string trueIconPath
    property string falseIconPath
    property color bkColor
    property color pressedBkColor
    property bool _hold
//    property var _offDSignal
    property string _sigId

    Image {
        id: iconImg
        width: iconWidth
        height: iconHeight
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Connections {
        target: mouseArea
        function onClicked(){
            defaultStatus = !defaultStatus;
            refreshIcon();
            formFieldInfo();
            emitSignalByStatus();
        }
        function onPressed(){ iconBtn.color = pressedBkColor; }
        function onReleased(){ iconBtn.color = bkColor; }
    }

    onEnabledChanged: {
        procEnabledStatus();
    }

    Component.onCompleted: {
        _sigId = dSignal.sigId;
        refreshIcon();
        formFieldInfo();
        procEnabledStatus();
    }

    function procEnabledStatus(){
        if(iconBtn.enabled)
            iconBtn.color = "#00000000"
        else
            iconBtn.color = "#30000000"
    }

    function emitSignalByStatus(){
        if(defaultStatus)
            dSignal["sigId"] = _sigId + "-ON";
        else
            dSignal["sigId"] = _sigId + "-OFF";
        EmitSignal.emitSignal(dSignal);
    }

    function refreshIcon(){
        if(defaultStatus)
            iconImg.source = "file:" + trueIconPath;
        else
            iconImg.source = "file:" + falseIconPath;
    }

    function formFieldInfo(){
        fieldInfo[_sigId] = defaultStatus;
    }
}
