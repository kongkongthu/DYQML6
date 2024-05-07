#ifndef DYBACKEND_H
#define DYBACKEND_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QHash>
#include "guifileloader.h"


class DYBackEnd : public QObject
{
    Q_OBJECT
public:
    explicit DYBackEnd(bool ifGenFakeData = true, QQmlApplicationEngine *parent = nullptr);
    GuiFileLoader* getGUILoader(){return _guiLoader;}
    void initTestTriggerGui();
    Q_INVOKABLE void receiveFromQml(QVariantMap dSignal);
    Q_INVOKABLE QVariant getHashDataObj(QStringList dataIdList);
    Q_INVOKABLE QVariantList getHashDataList(QStringList dataIdList);
    Q_INVOKABLE QVariant getHashData(QString dataId);
    Q_INVOKABLE QVariant getHashDataItem(QString dataId, QString itemName);

private:
    QQmlApplicationEngine* _engine = nullptr;
    GuiFileLoader* _guiLoader = nullptr;
    QHash<QString, QVariantMap> _dyHash;
    QStringList _dataItems = {"name", "value", "unit"};
    bool _ifGenFakeData;

    void _initGenFakeHashData();

signals:

};

#endif // DYBACKEND_H
