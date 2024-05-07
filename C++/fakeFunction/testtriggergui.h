#ifndef TESTTRIGGERGUI_H
#define TESTTRIGGERGUI_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QVariantMap>
#include "./../qmlinterface.h"

class testTriggerGUI : public QObject
{
    Q_OBJECT
public:
    explicit testTriggerGUI(QQmlApplicationEngine* engine, QObject *parent = nullptr);

private:
    QmlInterface* _qmlInterface;

signals:

};

#endif // TESTTRIGGERGUI_H
