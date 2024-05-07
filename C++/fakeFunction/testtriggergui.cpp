#include "testtriggergui.h"


testTriggerGUI::testTriggerGUI(QQmlApplicationEngine *engine, QObject *parent)
{
    this->_qmlInterface = new QmlInterface(engine, this);
    QVariantMap json;
    json["sigId"] = "sig-from-DYTempTest-class";
    json["destCode"] = 110;
    QVariantMap subInfo;
    subInfo["setValue"] = 333;
    subInfo["setUnit"] = "cm";
    json["subInfo"] = subInfo;
    _qmlInterface->triggerQML(json);
}
