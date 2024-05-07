import QtQuick 2.15
import QtQuick.Controls

DObject {
    id: busyIndicator
    BusyIndicator{
        anchors.fill: parent
        running: true
//        palette.dark: "red"
    }

    function postProcStatusOnSignal(){
        ;
    }
}
