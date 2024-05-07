import QtQuick 2.15
import QtQuick.Controls 2.15
import "./../js/procColorSpace.js" as ProcColor
//import QtQuick 3.1

Rectangle {
    id: dObject
    width: 100
    height: 100
    color: "#00000000"
    property string dyType
    property string dyName
    property var dyAnchors
    property string ctrlType
    property var visibleByList: []
    property var invisibleByList: []
    property var enableByList: []
    property var disableByList: []
    property string tipText
    property int tipTimeOut: 1000
    property Component toolTipComp: Qt.createComponent("./DYToolTip.qml")
    property var toolTipObj


    MouseArea{
        anchors.fill: parent
        hoverEnabled: frontEnd.showTip
        onEntered: createToolTipObj();
        onExited: destroyToolTipObj()
    }

    function createToolTipObj(){
        if(tipText){
            let tipParas = {
                "text": tipText,
                "timeout": tipTimeOut,
                "visible": true,
            };
            toolTipObj = toolTipComp.createObject(dObject, tipParas);
        }
    }

    function destroyToolTipObj(){
        if(toolTipObj)
            toolTipObj.destroy();
    }



    Connections{
        target: frontEnd
        function onSigTriggerFrontEnd (dSignal){
            procStatusOnSignal(dSignal);
            postProcStatusOnSignal(dSignal);
        }

        function onColorSpaceChanged(){
            refreshDObjectColor();
            refreshColor();
        }
    }

    function refreshDObjectColor(){
        border.color = ProcColor.judgeUpdataColor(border.color, "baseBorderColor")
        dObject.color = ProcColor.judgeUpdataColor(dObject.color, "primaryColor")
    }

    function refreshColor(){
        // overwrite func, realize in heritor of DObject
    }

    function procStatusOnSignal(dSignal){
        if(visibleByList.includes(dSignal.sigId))
            visible = true;
        if(invisibleByList.includes(dSignal.sigId))
            visible = false;
        if(enableByList.includes(dSignal.sigId))
            enabled = true;
        if(disableByList.includes(dSignal.sigId))
            enabled = false;
    }

    function postProcStatusOnSignal(dSignal){}//如有需要在子控件内实现
}
