import QtQuick
import QtQuick.Window
import Qt.labs.platform 1.1
//import "./qml/controls/baseControls"
import "./qml/js/parseParameters.js" as ParseFunc
import "./qml/controls"

Window {
    id: frontEnd
    visible: true
//    visibility: Window.FullScreen
    minimumWidth: 1024
    minimumHeight: 768
    color: colorSpace.backgroundColor
    title: qsTr("Hello World")

    property var topArea
    property var frontEndJson
    property var guiJson
    property string fontFamily
    property var colorSpace
    property var dyValues: undefined
    property var lastColorSpace
    property bool showTip: false
    property var shortcutObjList:[]
    property color undefinedColor
    property Component shortcutComp: Qt.createComponent("./qml/controls/baseControls/DYShortcut.qml")

    signal sigShowGUIChoosePage()
    signal sigTriggerGUI(var dSignal)
    signal sigTriggerConfirm(var dSignal)
    signal sigTriggerBackEnd(var dSignal)
    signal sigTriggerFrontEnd(var dSignal)//会被sigTriggerGUI与sigTriggerConfirm触发

    DYColorSpace{
        id: dyColor
    }

///////////////////////////////////////////////////////////////////////////
// Design Area: you can change the code of this area.
///////////////////////////////////////////////////////////////////////////

    Text {
        id: centerText
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -60
        text: qsTr("Ctrl+O: Open GUI Config File\nCtrl+F: Switch FullScreen\nCtrl+Q: Quit the Application")
        color: colorSpace.placeholderFontColor//"#9e9e9e"
        font.pixelSize: 40
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Text{
        id: bomTipText
        color: colorSpace.secondaryFontColor
        font.pixelSize: 30
        text: "You can design this page as you wish"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 210
    }

    Text{
        id: secondTipText
        color: colorSpace.secondaryFontColor
        font.pixelSize: 20
        text: "(Default loading GUI json file in 'Default' folder)"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 180
    }

///////////////////////////////////////////////////////////////////////////////
// Functional Area: Do not try to change the code below unless you well
// study the structure of DYQML and know how to improve the code, otherwise
// you may destroy of breakdown the function of the DYQML system. you can
// design default page and change the code above.
///////////////////////////////////////////////////////////////////////////////

    Shortcut{
        id: keyOfShowSelectPage
        context: Qt.ApplicationShortcut
        sequence: "Ctrl+O"
        onActivated: sigShowGUIChoosePage()
    }

    Shortcut{
        id: keyOfQuitApp
        context: Qt.ApplicationShortcut
        sequence: "Ctrl+Q"
        onActivated: frontEnd.close()
    }

    Shortcut{
        id: keySwitchFullScreen
        context: Qt.ApplicationShortcut
        sequence: "Ctrl+F"
        onActivated: {
            if(frontEnd.visibility == Window.FullScreen)
                frontEnd.visibility = Window.Windowed;
            else
                frontEnd.visibility = Window.FullScreen;
        }
    }

    Shortcut{
        id: keyReloadGUI
        context: Qt.ApplicationShortcut
        sequence: "Ctrl+R"
        onActivated: fileLoader.reloadGUI()
    }

    FileDialog{
        id: chooseJsonDialog
        title: qsTr("Choose a GUI Config Json File")
        nameFilters: ["JSON Files (*.json)", "*.*"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            let jsonFilePath = chooseJsonDialog.file;
            let currentFile = chooseJsonDialog.currentFile;
            fileLoader.jsonHasChosen(jsonFilePath);
        }
    }

    Timer {
        id: freshTimer
        running: true
        repeat: true
        interval: 200
    }

    Component{
        id: areaComp
        DYArea{
            anchors.fill: parent
            clip: true
        }
    }

    onSigShowGUIChoosePage: {
        console.log("Open Gui Choose Page.");
        chooseJsonDialog.open();
    }

    Connections{
        target: fileLoader
        function onJsonHasRead(jsonStr){
            console.log(`json has read`);
            frontEndJson = JSON.parse(jsonStr);
            destroyGUI();
            generateGUI();
        }
    }

    Connections {
        target: frontEnd
        function onSigTriggerGUI(dSignal){sigTriggerFrontEnd(dSignal);}
        function onSigTriggerConfirm(dSignal){sigTriggerFrontEnd(dSignal);}
        function onSigTriggerFrontEnd(dSignal){
            console.log(`signal trigger frontend, and dSignal = ${
                        JSON.stringify(dSignal)
                        }`);
            if(dSignal.sigId === "SWITCH-TO-SPECIFIED-FONT-FAMILY"){
                if(dSignal.subInfo.fontFamily)
                    frontEnd.fontFamily = dSignal.subInfo.fontFamily;
                if(dSignal.subInfo.item){
                    try{
                        frontEnd.fontFamily = dSignal.subInfo.item;
                    }catch(err){}
                }
            }
            if(dSignal.sigId === "SET-COLORSPACE")
                setCrtColorSpace(dSignal["subInfo"]);
        }
        function onSigTriggerBackEnd(dSignal){
            console.log(`signal trigger backend, and dSignal = ${
                        JSON.stringify(dSignal)
                        }`);
            backend.receiveFromQml(dSignal);
        }
    }

    function setCrtColorSpace(colorSpaceObj){
        lastColorSpace = JSON.parse(JSON.stringify(colorSpace));
        let preLastBorderColor = lastColorSpace.baseBorderColor;
        colorSpace = Object.assign(colorSpace, colorSpaceObj);
        let postLastBorderColor = lastColorSpace.baseBorderColor;
        let crtBorderColor = colorSpace.baseBorderColor;
    }

    function destroyGUI(){
        if(topArea)
            topArea.destroy();
        if(shortcutObjList.length!==0)
            shortcutObjList = [];
        if(centerText)
            centerText.destroy();
        if(bomTipText)
            bomTipText.destroy();
        if(secondTipText)
            secondTipText.destroy();
        if(dyValues)
            dyValues = undefined;
    }

    function generateGUI(){
        resizeWindow();
        generateGlobalValues();
        modifyColorSpace();
        guiJson = frontEndJson["topArea"];
        guiJson["ctrlType"] = "topArea";
        let paras = ParseFunc.parseParas(frontEnd, guiJson);
        frontEnd.showTip = paras.showTip;
        frontEnd.fontFamily = paras.fontFamily;
        delete paras.showTip;
        delete paras.fontFamily;
        topArea = areaComp.createObject(frontEnd, paras);
        addShortcut();
    }

    function resizeWindow(){
        if(frontEndJson["appSetting"] && frontEndJson["appSetting"]["width"]){
            frontEnd.minimumWidth = frontEndJson["appSetting"]["width"];
            frontEnd.width = frontEndJson["appSetting"]["width"];
        }else{
            frontEnd.minimumWidth = 1024;
            frontEnd.width = 1024;
        }
        if(frontEndJson["appSetting"] && frontEndJson["appSetting"]["height"]){
            frontEnd.minimumHeight =  frontEndJson["appSetting"]["height"];
            frontEnd.height = frontEndJson["appSetting"]["height"];
        }else{
            frontEnd.minimumHeight = 768;
            frontEnd.height = 768;
        }
    }

    function generateGlobalValues(){
        if(frontEndJson["appSetting"] && frontEndJson["appSetting"]["dyValues"])
            frontEnd.dyValues = frontEndJson["appSetting"]["dyValues"];
    }

    function modifyColorSpace(){
        colorSpace = JSON.parse(JSON.stringify(dyColor)); // restore the default colorSpace firstly.
        if(frontEndJson["appSetting"] && frontEndJson["appSetting"]["colorSpace"]){
            let colorSpaceSetting = frontEndJson["appSetting"]["colorSpace"];
            let keys = Object.keys(colorSpaceSetting);
            setCrtColorSpace(colorSpaceSetting);
        }
    }

    function addShortcut(){
        if(frontEndJson["appSetting"] && frontEndJson["appSetting"]["shortcutList"]){
            let shortcutList = frontEndJson["appSetting"]["shortcutList"];
            let paras;
            for(let i=0; i<shortcutList.length; i++){
                paras = {
                    "signalList": shortcutList[i].dSignalList,
                    "sequence": shortcutList[i].keys,
                };
                shortcutObjList.push(shortcutComp.createObject(frontEnd, paras));
            }
        }
    }

    Component.onDestruction: console.log(`Application start quits.`)

    Component.onCompleted: {
        colorSpace = JSON.parse(JSON.stringify(dyColor));
    }
}
