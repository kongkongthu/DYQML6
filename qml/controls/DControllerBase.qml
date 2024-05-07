import QtQuick 2.15

DObject {
    id: controllerBase
    dyType: "controller"
    property var crtInfo:({})
    property var dSignal:({"sigId":"", "destCode":"100", "subInfo":{}})
    property string fieldName
    property var fieldInfo: ({})
}
