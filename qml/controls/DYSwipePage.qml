import QtQuick.Controls
import QtQuick 2.15
import "./../js/parseParameters.js" as ParseFunc

DObject{
    id: dySwipePage
    color:"#00000000"
    property bool showBar
    property int tabHeight
    property color tabFontColor
    property bool showPageIndicator
    property color checkedBarColor
    property color uncheckedBarColor
    property var areaList: []
    property Component dyAreaComp: Qt.createComponent("DYArea.qml")

    Component{
        id: tabButtonComp
        TabButton{
            contentItem: Text {
                text: parent.text
                font.family: frontEnd.fontFamily
                opacity: enabled ? 1.0 : 0.3
                color: parent.down ? tabFontColor.lighter(1.3) : tabFontColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle{
                color: parent.checked ? dySwipePage.checkedBarColor : dySwipePage.uncheckedBarColor
            }
        }
    }

    TabBar{
        id: bar
        width: parent.width
        currentIndex: swipe.currentIndex
        visible: showBar
        height: visible ? tabHeight : 0
        contentHeight: bar.height
        background: Rectangle{
            color: dySwipePage.uncheckedBarColor.lighter(2.5)
        }
    }

    SwipeView{
        id: swipe
        width: bar.width
        height: showBar ? dySwipePage.height - bar.height : dySwipePage.height
        anchors.top: bar.bottom
        currentIndex: bar.currentIndex
        clip: true
    }

    PageIndicator{
        visible: showPageIndicator
        count: areaList.length
        currentIndex: swipe.currentIndex
        anchors.bottom: swipe.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: swipe.horizontalCenter
    }

    Component.onCompleted: {
        generate()
    }

    function generate(){
        for(let i=0; i<areaList.length; i++){
            let areaInfo = areaList[i];
            genTabButton(areaInfo.tabInfo);
            genPage(areaInfo);
        }
    }

    function genTabButton(tabInfo){
        if(tabInfo !== undefined){
            let paras = {
                "text": tabInfo.name,
                "icon.source": tabInfo.iconPath,
                "icon.width": tabInfo.iconPath ?
                                (tabInfo.iconWidth ? tabInfo.iconWidth : bar.height)
                                : undefined,
                "icon.height": tabInfo.iconPath ?
                                (tabInfo.iconHeight ? tabInfo.iconHeight : bar.height)
                                : undefined,
                "icon.color": tabInfo.iconPath ?
                                (tabInfo.iconColor ? tabInfo.iconColor : undefined) : tabFontColor,
            };
            let tabBtnObj = tabButtonComp.createObject(bar, paras);
        }
    }
    function genPage(pageInfo){
        let paras = ParseFunc.parseParas(swipe, pageInfo);
        let dyAreaObj = dyAreaComp.createObject(swipe, paras);
    }
}
