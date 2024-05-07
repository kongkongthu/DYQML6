import QtQuick 2.15
import QtQuick.Controls 2.15

ToolTip{
    id: tip
    timeout: 5000
    y: -height
    contentItem: Text{
        text: tip.text
        font.family: frontEnd.fontFamily
        color: frontEnd.colorSpace.primaryFontColor
    }
    background: Rectangle{
        border.color: frontEnd.colorSpace.baseBorderColor
        color: frontEnd.colorSpace.secondaryColor
    }
}
