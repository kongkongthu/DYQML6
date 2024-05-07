import QtQuick 2.15
import "./../js/procEmitSignal.js" as EmitSignal

DYArea {
    id: form
    property var dSignal:({})
    function postProcessOnSubObjs(){
        //方法重写，对子控件的后处理,这里用于获取按钮是否触发submit信号
        for(let i=0; i<subObjList.length; i++){
            if(subObjList[i].dyType==="submit")
                subObjList[i].sigSubmit.connect(emitForm);
        }
    }

    function emitForm(btnDSignal){
        formDSignal();
        EmitSignal.emitSignal(dSignal);
    }

    function formDSignal(){
        let subInfo = {};
        for(let i=0; i<subObjList.length; i++){
            if(subObjList[i].dyType==="controller"){
                Object.assign(subInfo, subObjList[i].fieldInfo);
            }
        }
        dSignal["subInfo"] = subInfo;
    }
}
