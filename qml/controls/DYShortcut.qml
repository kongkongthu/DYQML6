import QtQuick 2.15
import "./../js/procEmitSignal.js" as EmitSignal

Shortcut {
    property var signalList: []
    context: Qt.ApplicationShortcut
    onActivated: {
        for(let i=0; i<signalList.length; i++){
            try{
                EmitSignal.emitSignal(signalList[i]);
            }catch(err){
                console.log(`EmitSignal err in DYShortcut.qml`);
            }
        }
    }
}
