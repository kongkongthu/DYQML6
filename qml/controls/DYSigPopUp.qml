import QtQuick 2.15

DObject {
    id: dySigPopUP
    clip: true
    property int barHeight
    property int barSpacing: 5
    property int leftPadding: 5
    property int fontSize
    property int holdTime
    property color fontColor
    property color successColor
    property color warnColor
    property color errorColor
    property color triggerGUIColor
    property color triggerConfirmColor
    property color triggerBackendColor

    Flickable{
        anchors.fill: parent
        contentWidth: width
        contentHeight: height * 2
        Column{
            id: col
            spacing: barSpacing
            width: parent.width
            height: parent.contentHeight
            topPadding: 15

            move: Transition {
                id: moveTrans
                PathAnimation {
                    duration: 300
                    path: Path {
                        PathCurve {
                            x: moveTrans.ViewTransition.destination.x
                            y: moveTrans.ViewTransition.destination.y
                        }
                    }
                }
            }
        }
    }

    Component {
        id: barComp
        Rectangle{
            id: barRect
            width: col.width - 10
            height: barHeight
            color: barColor
            radius: 4
            clip: true
            property string barText: "text"
            property string guid
            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: dySigPopUP.leftPadding
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: dySigPopUP.leftPadding
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: fontSize
                color: fontColor
                text: barText
                clip: true
            }
            Timer{
                id: holdTimer
                interval: holdTime
                repeat: false
                running: true
            }
            Connections {
                target: holdTimer
                function onTriggered(){
                    barRect.destroy();
                }
            }
        }
    }

    Connections {
        target: frontEnd
        function onSigTriggerGUI(dSignal){
            addSignalBar(dSignal, "GUI");
        }
        function onSigTriggerConfirm(dSignal){
            addSignalBar(dSignal, "Confirm");
        }
        function onSigTriggerBackEnd(dSignal){
            addSignalBar(dSignal, "BackEnd");
        }
    }

    function addSignalBar(dSignal, triggerDest){
        let barText = genBarText(dSignal);
        let barColor = genBarColor(dSignal, triggerDest);
        let paras = {
            "barText": barText,
            "color": barColor,
        };
        let barObj = barComp.createObject(col, paras);
    }

    function genBarText(dSignal){
        if(dSignal["subInfo"]&&dSignal["subInfo"]["displayStr"])
            return dSignal["subInfo"]["displayStr"];
        if(dSignal["sigId"])
            return dSignal["sigId"];
    }

    function genBarColor(dSignal, triggerDest){
        if(dSignal["subInfo"] && dSignal["subInfo"]["sigColor"])
            return dSignal["subInfo"]["sigColor"];
        if(dSignal["subInfo"] && dSignal["subInfo"]["sigType"]){
            return getBarColorBySigType(dSignal["subInfo"]["sigType"]);
        }else{
            return getBarColorByDest(triggerDest);
        }
    }

    function getBarColorBySigType(sigType){
        switch(sigType){
        case "normal":
            return successColor;
        case "warn":
            return warnColor;
        case "error":
            return errorColor;
        }
    }

    function getBarColorByDest(triggerDest){
        switch(triggerDest){
        case "GUI":
            return triggerGUIColor;
        case "Confirm":
            return triggerConfirmColor;
        case "BackEnd":
            return triggerBackendColor;
        }
    }
}
