

function parseParas(parentObj, ctrlJson) {
    let colorSpace = frontEnd.colorSpace;
    let paras1 = preAddCommonAttribute(ctrlJson, parentObj);
    let paras2;
    switch(ctrlJson.ctrlType){
    case "topArea":
        paras2 = {
            "showTip": ctrlJson.showTip!==undefined ? ctrlJson.showTip : false,
            "fontFamily": ctrlJson.fontFamily ? ctrlJson.fontFamily : "Microsoft Yahei",
            "flickable": ctrlJson.flickable,
            "contentWidth": ctrlJson.contentWidth,
            "contentHeight": ctrlJson.contentHeight,
            "spacing": ctrlJson.spacing ? ctrlJson.spacing : 0,
            "layout": ctrlJson.layout ? ctrlJson.layout : "grid",
            "topPadding": ctrlJson.topPadding ? ctrlJson.topPadding : 0,
            "bottomPadding": ctrlJson.bottomPadding ? ctrlJson.bottomPadding : 0,
            "leftPadding": ctrlJson.leftPadding ? ctrlJson.leftPadding : 0,
            "rightPadding": ctrlJson.rightPadding ? ctrlJson.rightPadding : 0,
            "rows": ctrlJson.rows ? ctrlJson.rows : 2,
            "columns": ctrlJson.columns ? ctrlJson.columns : 2,
            "rowSpacing": ctrlJson.rowSpacing!==undefined ? ctrlJson.rowSpacing : ctrlJson.spacing,
            "columnSpacing": ctrlJson.columnSpacing!==undefined ? ctrlJson.columnSpacing : ctrlJson.spacing,
            "ctrlList": ctrlJson.ctrlList ? ctrlJson.ctrlList : [],
        };
        break;
    case "DYArea":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 200,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 100,
            "flickable": ctrlJson.flickable,
            "contentWidth": ctrlJson.contentWidth,
            "contentHeight": ctrlJson.contentHeight,
            "layout": ctrlJson.layout ? ctrlJson.layout : "grid",
            "layoutReverse": ctrlJson.layoutReverse,
            "spacing": ctrlJson.spacing ? ctrlJson.spacing : 0,
            "topPadding": ctrlJson.topPadding ? ctrlJson.topPadding :
                                                (ctrlJson.padding ? ctrlJson.padding : 0),
            "bottomPadding": ctrlJson.bottomPadding ? ctrlJson.bottomPadding :
                                                      (ctrlJson.padding ? ctrlJson.padding : 0),
            "leftPadding": ctrlJson.leftPadding ? ctrlJson.leftPadding :
                                                  (ctrlJson.padding ? ctrlJson.padding : 0),
            "rightPadding": ctrlJson.rightPadding ? ctrlJson.rightPadding :
                                                    (ctrlJson.padding ? ctrlJson.padding : 0),
            "rows": ctrlJson.rows ? ctrlJson.rows : 2,
            "columns": ctrlJson.columns ? ctrlJson.columns : 2,
            "rowSpacing": ctrlJson.rowSpacing ? ctrlJson.rowSpacing : (ctrlJson.spacing ? ctrlJson.spacing : 0),
            "columnSpacing": ctrlJson.columnSpacing ? ctrlJson.columnSpacing : (ctrlJson.spacing ? ctrlJson.spacing : 0),
            "ctrlList": ctrlJson.ctrlList ? ctrlJson.ctrlList : [],
        };
        break;
    case "DYForm":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 200,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 100,
            "flickable": ctrlJson.flickable,
            "contentWidth": ctrlJson.contentWidth,
            "contentHeight": ctrlJson.contentHeight,
            "layout": ctrlJson.layout ? ctrlJson.layout : "grid",
            "spacing": ctrlJson.spacing ? ctrlJson.spacing : 0,
            "topPadding": ctrlJson.topPadding ? ctrlJson.topPadding :
                                                (ctrlJson.padding ? ctrlJson.padding : 0),
            "bottomPadding": ctrlJson.bottomPadding ? ctrlJson.bottomPadding :
                                                      (ctrlJson.padding ? ctrlJson.padding : 0),
            "leftPadding": ctrlJson.leftPadding ? ctrlJson.leftPadding :
                                                  (ctrlJson.padding ? ctrlJson.padding : 0),
            "rightPadding": ctrlJson.rightPadding ? ctrlJson.rightPadding :
                                                    (ctrlJson.padding ? ctrlJson.padding : 0),
            "rows": ctrlJson.rows ? ctrlJson.rows : 2,
            "columns": ctrlJson.columns ? ctrlJson.columns : 2,
            "rowSpacing": ctrlJson.rowSpacing ? ctrlJson.rowSpacing : (ctrlJson.spacing ? ctrlJson.spacing : 0),
            "columnSpacing": ctrlJson.columnSpacing ? ctrlJson.columnSpacing : (ctrlJson.spacing ? ctrlJson.spacing : 0),
            "ctrlList": ctrlJson.ctrlList ? ctrlJson.ctrlList : [],
            "dSignal": ctrlJson.dSignal ? ctrlJson.dSignal : {},
        };
        break;
    case "DYLoader":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 200,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "areaList": ctrlJson.areaList ? ctrlJson.areaList : [],
            "border.color": colorSpace.fullTransparentColor,
            "border.width": 0,
            "color": colorSpace.fullTransparentColor,
            "defaultLoadIndex": ctrlJson.defaultLoadIndex!==undefined ? ctrlJson.defaultLoadIndex : -1,
            "clearSourceByList": ctrlJson.clearSourceByList ? ctrlJson.clearSourceByList : [],
            "setSourceByList": ctrlJson.setSourceByList ? ctrlJson.setSourceByList : [],
        };
        break;
    case "DYPlaceholder":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 10,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 10,
        }
        break;
    case "DYButton":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 120,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "name": ctrlJson.name,
            "holdStatus": ctrlJson.holdStatus,
            "defaultHold": ctrlJson.defaultHold,
            "nameX": ctrlJson.nameX ? ctrlJson.nameX :
                        (ctrlJson.imageX ? ctrlJson.imageX+(typeof(ctrlJson.width) === "number" ? ctrlJson.height : 30) :
                            120*0.1+(typeof(ctrlJson.width) === "number" ? ctrlJson.height : 30)),
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor : colorSpace.primaryFontColor,
            "imagePath": ctrlJson.imagePath,
            "imageX": ctrlJson.imageX ? ctrlJson.imageX :
                        (typeof(ctrlJson.width) === "number" ? ctrlJson.width * 0.1 : 120 * 0.1),
            "border.width": ctrlJson.borderWidth ? ctrlJson.borderWidth : 2,
            "radius": ctrlJson.radius ? ctrlJson.radius : 4,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "dSignal": ctrlJson.dSignal,
            "disableColor": ctrlJson.disableColor ? ctrlJson.disableColor : colorSpace.primaryDisableColor,
        }
        break;
    case "DYDataShower":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 200,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "name": ctrlJson.name ? ctrlJson.name : "NoName",
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor : colorSpace.primaryFontColor,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "hashKeys": ctrlJson.hashKeys ? ctrlJson.hashKeys : "",
            "unit": ctrlJson.unit ? ctrlJson.unit : "",
            "decimalNum": ctrlJson.decimalNum ? ctrlJson.decimalNum : 2,
        }
        break;
    case "DYSwitch":
        paras2 = {
            "fieldName": ctrlJson.fieldName ?
                                ctrlJson.fieldName :
                                (ctrlJson.dSignal ? ctrlJson.dSignal.sigId : "No-fieldName"),
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 120,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "name": ctrlJson.name,
            "dSignal": ctrlJson.dSignal,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor : colorSpace.primaryFontColor,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "onColor": ctrlJson.onColor ? ctrlJson.onColor : colorSpace.brandColor,
            "offColor": ctrlJson.offColor ? ctrlJson.offColor : colorSpace.secondaryColor,
            "dotColor": ctrlJson.dotColor ? ctrlJson.dotColor : colorSpace.baseBorderColor,
            "defaultValue": ctrlJson.defaultValue ? ctrlJson.defaultValue : false,
            "onText": ctrlJson.onText ? ctrlJson.onText : "ON",
            "offText": ctrlJson.offText ? ctrlJson.offText : "OFF",
        }
        break;
    case "DYComboBox":
        paras2 = {
            "name": ctrlJson.name,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor :
                                colorSpace.primaryFontColor,
            "bkColor": ctrlJson.bkColor ? ctrlJson.bkColor :
                                colorSpace.lighterBackgroundColor,
            "disableColor": ctrlJson.disableColor ? ctrlJson.disableColor :
                                colorSpace.primaryDisableColor,
            "dSignal": ctrlJson.dSignal,
            "itemList": ctrlJson.itemList ? ctrlJson.itemList : ["Item1", "Item2", "Item3"],
            "attachedValue": ctrlJson.attachedValue ? ctrlJson.attachedValue :
                                [1, 2, 3],
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 120,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
        }
        break;
    case "DYConfirmBtn":
        paras2 = {
            "name": ctrlJson.name ? ctrlJson.name : "NoName",
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 120,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "btnColor": ctrlJson.color ? ctrlJson.color : colorSpace.brandColor,
            "color": ctrlJson.color ? ctrlJson.color : colorSpace.brandColor,
            "fontColor": ctrlJson.fontColor ?
                ctrlJson.fontColor : colorSpace.primaryFontColor,
            "disableColor": ctrlJson.disableColor ?
                ctrlJson.disableColor : colorSpace.primaryDisableColor,
        }
        break;
    case "DYText":
        paras2 = {
            "text": ctrlJson.text ? ctrlJson.text : "NoText",
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 100,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "color": ctrlJson.color ? ctrlJson.color : colorSpace.fullTransparentColor,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "fontBold": ctrlJson.fontBold,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor
                            : colorSpace.primaryFontColor,
            "textHAlignment": ctrlJson.textHAlignment ? ctrlJson.textHAlignment : "left",
            "textVAlignment": ctrlJson.textVAlignment ? ctrlJson.textVAlignment : "top",
        }
        break;
    case "DYIconBtn":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 32,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 32,
            "iconWidth": ctrlJson.iconWidth ? ctrlJson.iconWidth :
                        (typeof(ctrlJson.width) === "number" ? ctrlJson.width : 32),
            "iconHeight": ctrlJson.iconHeight ? ctrlJson.iconHeight :
                        (typeof(ctrlJson.width) === "number" ? ctrlJson.height : 32),
            "trueIconPath": ctrlJson.trueIconPath,
            "falseIconPath": ctrlJson.falseIconPath,
            "dSignal": ctrlJson.dSignal,
            "bkColor": ctrlJson.bkColor ? ctrlJson.bkColor
                        : colorSpace.fullTransparentColor,
            "pressedBkColor": ctrlJson.pressedBkColor ? ctrlJson.pressedBkColor
                        : colorSpace.fullTransparentColor,
        };
        break;
    case "DYBlinkDot":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 24,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 24,
            "fromColor": ctrlJson.fromColor ? ctrlJson.fromColor :
                            (ctrlJson.color ? ctrlJson.color :
                                colorSpace.dangerColor),
            "toColor": ctrlJson.toColor ? ctrlJson.toColor :
                            (ctrlJson.color ? ctrlJson.color :
                                colorSpace.fullTransparentColor),
            "fromScale": ctrlJson.fromScale ? ctrlJson.fromScale : 0.3,
            "period": ctrlJson.period ? ctrlJson.period : 500,
            "reverse": ctrlJson.reverse,
        }
        break;
    case "DYTextInput":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 150,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor :
                            colorSpace.primaryFontColor,
            "bkColor": ctrlJson.bkColor ? ctrlJson.bkColor :
                            colorSpace.backgroundColor,
            "disableColor": ctrlJson.disableColor ? ctrlJson.disableColor :
                            colorSpace.primaryDisableColor,
            "dSignal": ctrlJson.dSignal ? ctrlJson.dSignal : {},
            "inputBorderColor": ctrlJson.inputBorderColor ? ctrlJson.inputBorderColor :
                            colorSpace.baseBorderColor,
            "inputBorderWidth": ctrlJson.inputBorderWidth ? ctrlJson.inputBorderWidth : 1,
            "inputBorderRadius": ctrlJson.inputBorderRadius ?
                            ctrlJson.inputBorderRadius : 5,
            "name": ctrlJson.name,
            "isPassword": ctrlJson.isPassword,
            "isNumber": ctrlJson.isNumber,
            "decimalNum": ctrlJson.decimalNum ? ctrlJson.decimalNum : 0,
            "minNum": ctrlJson.minNum ? ctrlJson.minNum : -99999999999,
            "maxNum": ctrlJson.maxNum ? ctrlJson.maxNum : 99999999999,
            "textHAlignment": ctrlJson.textHAlignment ? ctrlJson.textHAlignment : "left",
            "wrap": ctrlJson.wrap,//(ctrlJson.wrap!==undefined || ctrlJson.wrap) ? true : false,
        };
        break;
    case "DYBusyIndicator":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 40,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height: 40,
        };
        break;
    case "DYSlider":
        paras2 = {
            "name": ctrlJson.name,
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 100,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "showValue": (ctrlJson.showValue === undefined || ctrlJson.showValue) ? true : false,
            "decimalNum": ctrlJson.decimalNum ? ctrlJson.decimalNum : 2,
            "min": ctrlJson.min ? ctrlJson.min : 0,
            "max": ctrlJson.max ? ctrlJson.max : 1,
            "defaultValue": ctrlJson.defaultValue ? ctrlJson.defaultValue :
                            (ctrlJson.min ? ctrlJson.min : 0),
            "valueWidth": ctrlJson.valueWidth ? ctrlJson.valueWidth : 60,
            "dSignal": ctrlJson.dSignal ? ctrlJson.dSignal : {},
        };
        break;
    case "DYRadioButton":
        paras2 = {
            "name": ctrlJson.name ? ctrlJson.name : "NoName",
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 100,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 40,
            "checked": ctrlJson.checked,
            "disableColor": ctrlJson.disableColor ? ctrlJson.disableColor :
                            colorSpace.primaryDisableColor,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor :
                            colorSpace.primaryFontColor,
            "radioColor": ctrlJson.radioColor ? ctrlJson.radioColor :
                            colorSpace.brandColor,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "dSignal": ctrlJson.dSignal ? ctrlJson.dSignal : {},
            "unCheckedByList": ctrlJson.unCheckedByList ?
                            ctrlJson.unCheckedByList : [],
        };
        break;
    case "DYCheckBox":
        paras2 = {
            "name": ctrlJson.name ? ctrlJson.name : "NoName",
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 100,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 30,
            "checked": ctrlJson.checked,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor :
                            colorSpace.primaryFontColor,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "ctrlColor": ctrlJson.ctrlColor ? ctrlJson.ctrlColor :
                            colorSpace.brandColor,
            "dSignal": ctrlJson.dSignal ? ctrlJson.dSignal : {},
            "unCheckedByList": ctrlJson.unCheckedByList ?
                            ctrlJson.unCheckedByList : [],
        };
        break;
    case "DYSwipePage":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 300,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 400,
            "color": ctrlJson.color ? ctrlJson.color : colorSpace.fullTransparentColor,
            "showBar": ctrlJson.showBar !== undefined ? ctrlJson.showBar : true,
            "tabHeight": ctrlJson.tabHeight ? ctrlJson.tabHeight : 30,
            "tabFontColor": ctrlJson.tabFontColor ? ctrlJson.tabFontColor :
                                    colorSpace.primaryFontColor,
            "showPageIndicator": ctrlJson.showPageIndicator !== undefined ?
                                ctrlJson.showPageIndicator : true,
            "checkedBarColor": ctrlJson.checkedBarColor ?
                                ctrlJson.checkedBarColor : colorSpace.brandColor,
            "uncheckedBarColor": ctrlJson.uncheckedBarColor ?
                                ctrlJson.uncheckedBarColor : colorSpace.lightBackgroundColor,
            "areaList": ctrlJson.areaList ? ctrlJson.areaList : [],
        };
        break;
    case "DYSigPopUp":
        paras2 = {
            "width": typeof(ctrlJson.width) === "number" ? ctrlJson.width : 250,
            "height": typeof(ctrlJson.height) === "number" ? ctrlJson.height : 500,
            "barHeight": ctrlJson.barHeight ? ctrlJson.barHeight : 35,
            "barSpacing": ctrlJson.barSpacing ? ctrlJson.barSpacing : 5,
            "leftPadding": ctrlJson.leftPadding ? ctrlJson.leftPadding : 10,
            "fontSize": ctrlJson.fontSize ? ctrlJson.fontSize : 12,
            "holdTime": ctrlJson.holdTime ? ctrlJson.holdTime : 5000,
            "fontColor": ctrlJson.fontColor ? ctrlJson.fontColor : colorSpace.primaryFontColor,
            "successColor": ctrlJson.successColor ? ctrlJson.successColor : colorSpace.semiTransSuccessColor,
            "warnColor": ctrlJson.warnColor ? ctrlJson.warnColor : colorSpace.semiTransWarningColor,
            "errorColor": ctrlJson.errorColor ? ctrlJson.errorColor : colorSpace.semiTransDangerColor,
            "triggerGUIColor": ctrlJson.triggerGUIColor ?
                                    ctrlJson.triggerGUIColor : colorSpace.semiTransSuccessColor,
            "triggerConfirmColor": ctrlJson.triggerConfirmColor ?
                                    ctrlJson.triggerConfirmColor : colorSpace.semiTransSuccessColor,
            "triggerBackendColor": ctrlJson.triggerBackendColor ?
                                    ctrlJson.triggerBackendColor : colorSpace.semiTransWarningColor,

        };
        break;
    }
    if(paras1.dyName==="btn2")
        console.log(`btn2 color = ${paras1.color}`)
    let paras = Object.assign(paras1, paras2)
    return paras;
}

function preAddCommonAttribute(ctrlJson, parentObj){
    let colorSpace = frontEnd.colorSpace;
    let paras = {
        "ctrlType": ctrlJson.ctrlType,
        "dyName": ctrlJson.dyName,
        "x": ctrlJson.x,
        "y": ctrlJson.y,
        "clip": ctrlJson.clip,
        "dyAnchors": ctrlJson.anchors,
        "enabled": ctrlJson.enabled!==undefined ? ctrlJson.enabled : true,
        "radius": ctrlJson.radius ? ctrlJson.radius : 0,
        "color": ctrlJson.color ? ctrlJson.color : colorSpace.primaryColor,
        "border.color": ctrlJson.borderColor ?
                             ctrlJson.borderColor : colorSpace.baseBorderColor,
        "border.width": ctrlJson.borderWidth ? ctrlJson.borderWidth : 0,
        "tipText": ctrlJson.tipText ? ctrlJson.tipText : "",
        "tipTimeOut": ctrlJson.tipText ? (ctrlJson.tipTimeOut ? ctrlJson.tipTimeOut : 1000) : 0,
        "visibleByList": ctrlJson.visibleByList ? ctrlJson.visibleByList : [],
        "invisibleByList": ctrlJson.invisibleByList ? ctrlJson.invisibleByList : [],
        "enableByList": ctrlJson.enableByList ? ctrlJson.enableByList : [],
        "disableByList": ctrlJson.disableByList ? ctrlJson.disableByList : [],
    };
    return paras;
}
