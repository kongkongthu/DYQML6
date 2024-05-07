import QtQuick 2.15

DObject {
    id: showerBase
    dyType: "shower"
    Connections {
        target: freshTimer
        function onTriggered(){
            procReadData();
        }
    }

    function procReadData(){}//
}
