import QtQuick 2.15
import "./../js/parseParameters.js" as ParseFunc

DObject{
    id: dyLoader
    property string areaUrl: "DYArea.qml"
    property var areaList
    property var setSourceByList: []
    property var clearSourceByList: []
    property int defaultLoadIndex

    Loader{
        id: loader
        x: border.width
        y: border.width
        width: parent.width-2*parent.border.width
        height: parent.height-2*parent.border.width
    }


    function postProcStatusOnSignal(dSignal){
        if(setSourceByList.includes(dSignal.sigId))
            generateSubAreaByIndex(dSignal.subInfo.index);
        if(clearSourceByList.includes(dSignal.sigId))
            clearLoaderSource();
    }

    function setLoaderSource(){
        let index = 0;
        let paras = ParseFunc.parseParas(loader, areaList[index]);
        loader.setSource(areaUrl, paras);
    }

    function generateSubAreaByIndex(index){
        if(areaList.length > index){
            let paras = ParseFunc.parseParas(loader, areaList[index]);
            loader.setSource(areaUrl, paras);
        }else{
            console.log(`index exceed areaList range in DYLoader.qml`);
        }
    }

    function clearLoaderSource(){
        loader.setSource("");
    }

    Component.onCompleted: {
        if(defaultLoadIndex >= 0)
            generateSubAreaByIndex(defaultLoadIndex);
    }
}
