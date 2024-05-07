#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

#include <QObject>
#include <QString>
#include <QDebug>
#include <QQmlApplicationEngine>
#include <QtMath>

class QmlInterface : public QObject
{
    Q_OBJECT
public:
    explicit QmlInterface(QQmlApplicationEngine *engine, QObject *parent = nullptr);
    void triggerQML(QVariantMap dSignal);

private:
    QObject* _rootObject;

    void _procTrigger(QVariantMap json);
    void _triggerGUI(QVariantMap json);
    void _triggerConfirm(QVariantMap json);

signals:

};

#endif // QMLINTERFACE_H
