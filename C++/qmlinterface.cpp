#include "qmlinterface.h"

QmlInterface::QmlInterface(QQmlApplicationEngine *engine, QObject *parent)
    : QObject{parent}
{
    _rootObject = engine->rootObjects().first();
}

void QmlInterface::triggerQML(QVariantMap dSignal){
    if(dSignal["sigId"].isValid()){
        if(dSignal["destCode"].isNull()){
            dSignal["destCode"] = "100";
            this->_triggerGUI(dSignal);
        }else{
            this->_procTrigger(dSignal);
        }
    }else{
        qDebug() << "no sigId in the json of signal, which is "
                 << dSignal
                 << ", APP will do nothing";
    }
}

void QmlInterface::_procTrigger(QVariantMap json)
{
    QVariant code = json["destCode"];

    if(code.typeName() == QString("double"))
        json["destCode"] = QString::number(qFloor(code.toDouble()));
    else if(code.typeName() == QString("int"))
        json["destCode"] = code.toString();

    if(json["destCode"] == "100")
        this->_triggerGUI(json);
    else if(json["destCode"] == "010")
        this->_triggerConfirm(json);
    else if(json["destCode"] == "110"){
        this->_triggerGUI(json);
        this->_triggerConfirm(json);
    }
}

void QmlInterface::_triggerGUI(QVariantMap json){
    QMetaObject::invokeMethod(_rootObject, "sigTriggerGUI", Q_ARG(QVariant, json));
}

void QmlInterface::_triggerConfirm(QVariantMap json){
    QMetaObject::invokeMethod(_rootObject, "sigTriggerConfirm", Q_ARG(QVariant, json));
}
