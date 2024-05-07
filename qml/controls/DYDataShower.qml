import QtQuick 2.15
import "./../js/readHash.js" as ReadHash

DShowerBase{
    id: shower
    property int fontSize
    property string name
    property int nameWidth: 20
    property int unitWidth: 20
    property string unit
    property color fontColor
    property bool firstTime: true
    property bool manual: false
    property var hashKeys
    property int decimalNum

    Text{
        id: dataNameTxt
        width: nameWidth
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: shower.border.width + 10
        color: fontColor
        font.family: frontEnd.fontFamily
        font.pixelSize: fontSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: name+":"
    }

    Text{
        id: unitTxt
        width: unit ? unitWidth : 0
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: shower.border.width + 5
        color: fontColor
        font.family: frontEnd.fontFamily
        font.pixelSize: fontSize
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        text: unit
    }

    Text{
        id: valueTxt
        height: parent.height
        anchors.left: dataNameTxt.left
        anchors.right: unitTxt.left
        clip: true
        color: fontColor
        font.family: frontEnd.fontFamily
        font.pixelSize: fontSize
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        text: "---"
    }

    Connections {
        target: freshTimer
        function onTriggered(){
            if(visible)
                processReadData();
        }
    }

    function processReadData(){
        if(firstTime)
            procFirstTime();
        else
            procOtherTimes();
    }

    function procFirstTime(){
        firstTime = false;
        let jsonData;
        jsonData = ReadHash.readHashData(hashKeys);
        if(jsonData !== "None"){
            if(shower.name === "NoName")
                shower.name = jsonData.name;
            if(shower.unit === "")
                shower.unit = jsonData.unit;
            try{
                valueTxt.text = jsonData.value.toFixed(decimalNum);
            }catch(err){
                valueTxt.text = "---";
            }
        }
    }

    function procOtherTimes(){
        let jsonData = ReadHash.readHashDataItem(hashKeys, "value")
        try{
            valueTxt.text = jsonData.toFixed(decimalNum);
        }catch(err){
            valueTxt.text = "---";
        }
    }
}

