import QtQuick 2.15
import QtCharts 2.15
import "./../js/readHash.js" as ReadHash

DObject {
    id: dyBarChart
    property string barType
    property string barName
    // "vBar", "vPercentBar", "vStackedBar"
    // "hBar", "hPercentBar", "hStackedBar"
    property var barParas:({})
    property var barSetList: []
    property var barSetObjList: []
    property var barSetValueList: []
    property var categorieList: []
    property var barObj
    property int min
    property int max
    property color fontColor
    property color gridColor

    ChartView{
        id: chartView
        anchors.fill: parent
        title: barName
        titleColor: fontColor
        titleFont.family: frontEnd.fontFamily
        legend.alignment: Qt.AlignBottom
        antialiasing: true
        backgroundColor: dyBarChart.color
    }

    BarCategoryAxis{
        id: categoryAxis
        categories: categorieList
        color: gridColor.lighter(1.8)
        labelsColor: fontColor
        labelsFont.family: frontEnd.fontFamily
        gridLineColor: gridColor.lighter(1.8)
    }

    ValuesAxis {
        id: valueAxis
        min: dyBarChart.min ? dyBarChart.min : 0
        max: dyBarChart.max ? dyBarChart.max : 100
        labelsColor: fontColor
        labelsFont.family: frontEnd.fontFamily
        color: gridColor.lighter(1.8)
        gridLineColor: gridColor.lighter(1.8)
    }

    Component.onCompleted: {
        genBarObj();
    }

    function genBarObj(){
        let typeEnum;
        switch(barType){
        case "vBar":
            typeEnum = ChartView.SeriesTypeBar;
            break;
        case "vPercentBar":
            typeEnum = ChartView.SeriesTypePercentBar;
            break;
        case "vStackedBar":
            typeEnum = ChartView.SeriesTypeStackedBar;
            break;
        case "hBar":
            typeEnum = ChartView.SeriesTypeHorizontalBar;
            break;
        case "hPercentBar":
            typeEnum = ChartView.SeriesTypeHorizontalPercentBar;
            break;
        case "hStackedBar":
            typeEnum = ChartView.SeriesTypeHorizontalStackedBar;
            break;
        default:
            break;
        }
        if(barType==="vBar" || barType==="vPercentBar" || barType==="vStackedBar"){
            barObj = chartView.createSeries(typeEnum, barName, categoryAxis, valueAxis);
        }
        else if(barType==="hBar" || barType==="hPercentBar" || barType==="hStackedBar"){
            barObj = chartView.createSeries(typeEnum, barName, valueAxis, categoryAxis);
        }
        genBarSets();
    }

    function genBarSets(){
        barSetObjList = [];
        genInitValueList();
        let barSet;
        for(let i=0; i<barSetList.length; i++){
            barSet = barObj.append(barSetList[i].label, barSetValueList[i]);
            barSetObjList.push(barSet);
            if(barSetList[i].color)
                barSet.color = barSetList[i].color;
            barSet.labelColor = fontColor;
        }
    }

    function genInitValueList(){
        barSetValueList = [];
        let valueList = [];
        for(let i=0; i<barSetList.length; i++){
            valueList = [];
            for(let j=0; j<barSetList[i].guidList.length; j++)
                valueList.push(0);
            barSetValueList.push(valueList)
        }
    }

    Connections {
        target: freshTimer
        function onTriggered(){
            if(visible){
                for(let i=0; i<barSetList.length; i++){
                    for(let j=0; j<barSetList[i].guidList.length; j++)
                        barObj.at(i).replace(j, ReadHash.readHashData(barSetList[i].guidList[j]).value)
                }
            }
        }
    }

//    Connections {
//        target: frontEnd
//        function onSigTriggerFrontEnd(dSignal){
//            ;
//        }
//    }
}
