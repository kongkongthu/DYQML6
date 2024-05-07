import QtQuick 2.15
import "./../js/parseParameters.js" as ParseFunc
import "./../js/procColorSpace.js" as ProcColor
import Qt5Compat.GraphicalEffects

DObject {
    id: area
    property string layout
    property int rows
    property int columns
    property bool flickable
    property int contentWidth
    property int contentHeight
    property int spacing
    property int columnSpacing
    property int rowSpacing
    property int leftPadding
    property int rightPadding
    property int topPadding
    property int bottomPadding
    property var flickableObj
    property var alignObj
    property bool layoutReverse
    property var ctrlList: []
    property var subObjList: []
    property var generateByList: []
    property var destoryByList: []

    property Component dyAreaComp: Qt.createComponent("DYArea.qml")
    property Component dyFormComp: Qt.createComponent("DYForm.qml")
    property Component dyDataShowerComp: Qt.createComponent("DYDataShower.qml")
    property Component dyLoaderComp: Qt.createComponent("DYLoader.qml")
    property Component dyPlaceholderComp: Qt.createComponent("DYPlaceholder.qml")
    property Component dyButtonComp: Qt.createComponent("DYButton.qml")
    property Component dySwitchComp: Qt.createComponent("DYSwitch.qml")
    property Component dyComboBoxComp: Qt.createComponent("DYComboBox.qml")
    property Component dyConfirmBtnComp: Qt.createComponent("DYConfirmBtn.qml")
    property Component dyTextComp: Qt.createComponent("DYText.qml")
    property Component dyIconBtnComp: Qt.createComponent("DYIconBtn.qml")
    property Component dyBlinkDotComp: Qt.createComponent("DYBlinkDot.qml")
    property Component dyTextInputComp: Qt.createComponent("DYTextInput.qml")
    property Component dyBusyIndicatorComp: Qt.createComponent("DYBusyIndicator.qml")
    property Component dySliderComp: Qt.createComponent("DYSlider.qml")
    property Component dyRadioButtonComp: Qt.createComponent("DYRadioButton.qml")
    property Component dyCheckBoxComp: Qt.createComponent("DYCheckBox.qml")
    property Component dySwipePageComp: Qt.createComponent("DYSwipePage.qml")
    property Component dySigPopUpComp: Qt.createComponent("DYSigPopUp.qml")

    Component{
        id: flickableComp
        Flickable{
            clip: true
            anchors.fill: parent
        }
    }

    Component{
        id: rowComp
        Row{
            anchors.fill: parent
            spacing: area.spacing
            leftPadding: area.leftPadding
            topPadding: area.topPadding
            layoutDirection: layoutReverse ? Qt.RightToLeft : Qt.LeftToRight
        }
    }

    Component {
        id: columnComp
        Column {
            anchors.fill: parent
            spacing: area.spacing
            leftPadding: area.leftPadding
            topPadding: area.topPadding
        }
    }

    Component {
        id: gridComp
        Grid{
            anchors.fill: parent
            spacing: area.spacing
            columns: area.columns
            rows: area.rows
            columnSpacing: area.columnSpacing
            rowSpacing: area.rowSpacing
            leftPadding: area.leftPadding
            topPadding: area.topPadding
            layoutDirection: layoutReverse ? Qt.RightToLeft : Qt.LeftToRight
        }
    }


    Component.onCompleted: {
        generateFlickableObj();
        generateAlignmentObj();
        generateSubCtrls();
    }

    function destorySubCtrls(){}

    function postProcessOnSubObjs(){
    }//对子控件的后处理，在generateSubCtrls()的最后调用，在子类如DYForm中具体实现


    function generateSubCtrls(){
        let ctrlObj, paras;
        let objParent = flickable ? flickableObj.contentItem : area;
        for(let i=0; i<ctrlList.length; i++){
            let ctrlJson = ctrlList[i];
            paras = ParseFunc.parseParas(objParent, ctrlJson);
            switch(ctrlJson.ctrlType){
            case "DYArea":
                ctrlObj = dyAreaComp.createObject(objParent, paras);
                break;
            case "DYForm":
                ctrlObj = dyFormComp.createObject(objParent, paras);
                break;
            case "DYDataShower":
                ctrlObj = dyDataShowerComp.createObject(objParent, paras);
                break;
            case "DYPlaceholder":
                ctrlObj = dyPlaceholderComp.createObject(objParent,paras);
                break;
            case "DYButton":
                ctrlObj = dyButtonComp.createObject(objParent, paras);
                break;
            case "DYLoader":
                ctrlObj = dyLoaderComp.createObject(objParent, paras);
                break;
            case "DYSwitch":
                ctrlObj = dySwitchComp.createObject(objParent, paras);
                break;
            case "DYComboBox":
                ctrlObj = dyComboBoxComp.createObject(objParent, paras);
                break;
            case "DYConfirmBtn":
                ctrlObj = dyConfirmBtnComp.createObject(objParent, paras);
                break;
            case "DYText":
                ctrlObj = dyTextComp.createObject(objParent, paras);
                break;
            case "DYIconBtn":
                ctrlObj = dyIconBtnComp.createObject(objParent, paras);
                break;
            case "DYBlinkDot":
                ctrlObj = dyBlinkDotComp.createObject(objParent, paras);
                break;
            case "DYTextInput":
                ctrlObj = dyTextInputComp.createObject(objParent, paras);
                break;
            case "DYBusyIndicator":
                ctrlObj = dyBusyIndicatorComp.createObject(objParent, paras);
                break;
            case "DYSlider":
                ctrlObj = dySliderComp.createObject(objParent, paras);
                break;
            case "DYRadioButton":
                ctrlObj = dyRadioButtonComp.createObject(objParent, paras);
                break;
            case "DYCheckBox":
                ctrlObj = dyCheckBoxComp.createObject(objParent, paras);
                break;
            case "DYSwipePage":
                ctrlObj = dySwipePageComp.createObject(objParent, paras);
                break;
            case "DYSigPopUp":
                ctrlObj = dySigPopUpComp.createObject(objParent, paras);
                break;
            }
            if(inAlignment(paras))
                ctrlObj.parent = alignObj;
            subObjList.push(ctrlObj);
        }
        procAllAnchorsAndSize();
        postProcessOnSubObjs();
    }

    function procAllAnchorsAndSize(){
        for(let i=0; i<ctrlList.length; i++){
            let ctrlJson = ctrlList[i];
            let ctrlObj = subObjList[i];

            if(ctrlObj.parent !== alignObj)
                processingAnchors(ctrlJson, ctrlObj);

            if(typeof(ctrlJson.width) === "string")
                processingWidth(ctrlJson.width, ctrlObj);
            if(typeof(ctrlJson.height) === "string")
                processingHeight(ctrlJson.height, ctrlObj);
        }
    }

    function processingWidth(widthStr, ctrlObj){
        console.log(`in func processingWidth, and widthStr = ${widthStr}`);
//        if(widthStr.includes("/")){
//            console.log("contain operate symbol: /")
            let widthStrList = findAndSplit("111+222*333-444/555");
            console.log(`widthStrList = ${widthStrList}`)
//        }
    }

    function processingHeight(heightStr, ctrlObj){
//        console.log(`in func processingHeight, and heightStr = ${heightStr}`);
        if(heightStr.includes("/")){
//            console.log("contain operate symbol: /")
//            let heightStrList = findAndSplit("1+333*3-4/5");
//            console.log(`heightStrList = ${heightStrList}`)
        }
    }

    function findAndSplit(str) {
        const symbols = ["+", "-", "*", "/"];
        const splitPoints = [];
        let lastIndex = 0
        let sliceStr
        for(let i=0; i<str.length; i++){
            if(symbols.includes(str[i])){
                sliceStr = str.slice(lastIndex, i)
                splitPoints.push(sliceStr)
                splitPoints.push("symbol:"+str[i])
                lastIndex = i+1
            }
            if(i === str.length-1)
                splitPoints.push(str.slice(lastIndex, i))
        }
        return splitPoints;
    }

    function processingAnchors(ctrlJson, ctrlObj){
        if(ctrlJson.anchors){
            let anchorsInfo = ctrlJson.anchors;
            if(anchorsInfo.fill)
                ctrlObj.anchors.fill = fetchDestObjAnchors(anchorsInfo.fill);
            else{
                if(anchorsInfo.left){
                    ctrlObj.anchors.left = fetchDestObjAnchors(anchorsInfo.left);
                    ctrlObj.anchors.leftMargin = anchorsInfo.leftMargin ?
                                anchorsInfo.leftMargin : 0;
                }
                if(anchorsInfo.right){
                    ctrlObj.anchors.right = fetchDestObjAnchors(anchorsInfo.right);
                    ctrlObj.anchors.rightMargin = anchorsInfo.rightMargin ?
                                anchorsInfo.rightMargin : 0;
                }
                if(anchorsInfo.top){
                    ctrlObj.anchors.top = fetchDestObjAnchors(anchorsInfo.top);
                    ctrlObj.anchors.topMargin = anchorsInfo.topMargin ?
                                anchorsInfo.topMargin : 0;
                }
                if(anchorsInfo.bottom){
                    ctrlObj.anchors.bottom = fetchDestObjAnchors(anchorsInfo.bottom);
                    ctrlObj.anchors.bottomMargin = anchorsInfo.bottomMargin ?
                                anchorsInfo.bottomMargin : 0;
                }
                if(anchorsInfo.horizontalCenter){
                    ctrlObj.anchors.horizontalCenter = fetchDestObjAnchors(anchorsInfo.horizontalCenter);
                    ctrlObj.anchors.horizontalCenterOffset =
                            anchorsInfo.horizontalCenterOffset ?
                                anchorsInfo.horizontalCenterOffset : 0;
                }
                if(anchorsInfo.verticalCenter){
                    ctrlObj.anchors.verticalCenter = fetchDestObjAnchors(anchorsInfo.verticalCenter);
                    ctrlObj.anchors.verticalCenterOffset =
                            anchorsInfo.verticalCenterOffset ?
                                anchorsInfo.verticalCenterOffset : 0;
                }
            }
        }
    }

    function fetchDestObjAnchors(info){
        let parts = info.split(".");
        let cName = parts[0];
        let cAnchors = parts[1];
        let destCtrl;
        if(cName === dyName || cName ==="parent")
            destCtrl = area;
        else{
            for(let i=0; i<subObjList.length; i++){
                if(subObjList[i].dyName===cName){
                    destCtrl = subObjList[i];
                    break;
                }
            }
        }
        switch(cAnchors){
        case "left":
            return destCtrl.left;
        case "right":
            return destCtrl.right;
        case "top":
            return destCtrl.top;
        case "bottom":
            return destCtrl.bottom;
        case "horizontalCenter":
            return destCtrl.horizontalCenter;
        case "verticalCenter":
            return destCtrl.verticalCenter;
        default:
            return destCtrl;
        }
    }

    function inAlignment(paras){
        let result = paras.x!==undefined || paras.y!==undefined || paras.dyAnchors!==undefined
        return !result;
    }

    function generateFlickableObj(){
        if(area.flickable){
            let paras = {
                "width": area.width,
                "height": area.height,
                "contentWidth": area.contentWidth,
                "contentHeight": area.contentHeight,
                "flickableDirection": Flickable.AutoFlickIfNeeded,
            }
            flickableObj = flickableComp.createObject(area, paras);
        }
    }

    function generateAlignmentObj(){
        let objParent;
        let paras;
        if(flickable){
            objParent = flickableObj.contentItem;
            paras = {
                "width": flickableObj.contentWidth,
                "height": flickableObj.contentHeight,
            }
        }
        else{
            objParent = area;
            paras = {
                "width": area.width,
                "height": area.height,
            }
        }
        switch(layout){
        case "row":
            alignObj = rowComp.createObject(objParent, paras);
            break;
        case "column":
            alignObj = columnComp.createObject(objParent, paras);
            break;
        case "grid":
            alignObj = gridComp.createObject(objParent, paras);
            break;
        }
    }

    Connections{
        target: frontEnd
        function onColorSpaceChanged(){
            for(let i=0; i<subObjList.length; i++){
                ProcColor.upDataColorByCtrlType(subObjList[i]);
            }
        }
    }
}
