function judgeUpdataColor(crtColor, colorName){
    let lastColor = Qt.color(frontEnd.lastColorSpace[colorName]);
    let newColor = Qt.color(frontEnd.colorSpace[colorName]);
    if(crtColor === lastColor)
        return newColor;
    else
        return crtColor;
}

function upDataColorByCtrlType(ctrlObj){
    let colorSpace = frontEnd.colorSpace;
    switch(ctrlObj.ctrlType){
    case "topArea":
        break;
    case "DYArea":
        break;
    case "DYForm":
        break;
    case "DYLoader":
        ctrlObj.border.color = colorSpace.fullTransparentColor;
        ctrlObj.color = colorSpace.fullTransparentColor;
        break;
    case "DYPlaceholder":
        break;
    case "DYButton":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        break;
    case "DYDataShower":
        break;
    case "DYSwitch":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.onColor = judgeUpdataColor(ctrlObj.onColor, "brandColor");
        ctrlObj.offColor = judgeUpdataColor(ctrlObj.offColor, "secondaryColor");
        ctrlObj.dotColor = judgeUpdataColor(ctrlObj.dotColor, "baseBorderColor");
        break;
    case "DYComboBox":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.bkColor = judgeUpdataColor(ctrlObj.bkColor, "lighterBackgroundColor");
        ctrlObj.disableColor = judgeUpdataColor(ctrlObj.disableColor, "primaryDisableColor")
        break;
    case "DYConfirmBtn":
        ctrlObj.btnColor = judgeUpdataColor(ctrlObj.btnColor, "brandColor");
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.disableColor = judgeUpdataColor(ctrlObj.disableColor, "primaryDisableColor");
        break;
    case "DYText":
        ctrlObj.color = judgeUpdataColor(ctrlObj.color, "fullTransparentColor");
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        break;
    case "DYIconBtn":
        ctrlObj.bkColor = judgeUpdataColor(ctrlObj.bkColor, "fullTransparentColor");
        ctrlObj.pressedBkColor = judgeUpdataColor(ctrlObj.pressedBkColor, "fullTransparentColor");
        break;
    case "DYBlinkDot":
        ctrlObj.fromColor = judgeUpdataColor(ctrlObj.fromColor, "dangerColor");
        ctrlObj.toColor = judgeUpdataColor(ctrlObj.toColor, "fullTransparentColor");
        break;
    case "DYTextInput":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.bkColor = judgeUpdataColor(ctrlObj.bkColor, "backgroundColor");
        ctrlObj.inputBorderColor = judgeUpdataColor(ctrlObj.inputBorderColor, "baseBorderColor");
        ctrlObj.disableColor = judgeUpdataColor(ctrlObj.disableColor, "primaryDisableColor");
        break;
    case "DYBusyIndicator":
        break;
    case "DYSlider":
        break;
    case "DYRadioButton":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.radioColor = judgeUpdataColor(ctrlObj.radioColor, "brandColor");
        ctrlObj.disableColor = judgeUpdataColor(ctrlObj.disableColor, "primaryDisableColor");
        break;
    case "DYCheckBox":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.ctrlColor = judgeUpdataColor(ctrlObj.ctrlColor, "brandColor");
        break;
    case "DYSwipePage":
        ctrlObj.tabFontColor = judgeUpdataColor(ctrlObj.tabFontColor, "primaryFontColor");
        ctrlObj.checkedBarColor = judgeUpdataColor(ctrlObj.checkedBarColor, "brandColor");
        ctrlObj.uncheckedBarColor = judgeUpdataColor(ctrlObj.uncheckedBarColor, "lightBackgroundColor");
        break;
    case "DYPopUp":
        ctrlObj.fontColor = judgeUpdataColor(ctrlObj.fontColor, "primaryFontColor");
        ctrlObj.successColor = judgeUpdataColor(ctrlObj.successColor, "semiTransSuccessColor");
        ctrlObj.warnColor = judgeUpdataColor(ctrlObj.warnColor, "semiTransWarningColor");
        ctrlObj.errorColor = judgeUpdataColor(ctrlObj.errorColor, "semiTransDangerColor");
        ctrlObj.triggerGUIColor = judgeUpdataColor(ctrlObj.triggerGUIColor, "lighterTransBrandColor");
        ctrlObj.triggerConfirmColor = judgeUpdataColor(ctrlObj.triggerConfirmColor, "semiTransBrandColor");
        ctrlObj.triggerBackendColor = judgeUpdataColor(ctrlObj.triggerBackendColor, "darkerTransBrandColor");
        break;
    }
}

//function updataCommonColor(ctrlObj){
//    ctrlObj
//}
