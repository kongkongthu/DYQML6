#include "dybackend.h"
#include "./fakeFunction/testtriggergui.h"
#include "./fakeFunction/genfakehashdata.h"

DYBackEnd::DYBackEnd(bool ifGenFakeData, QQmlApplicationEngine *parent)
{
    _engine = parent;
    this->_guiLoader = new GuiFileLoader(this);
    if(ifGenFakeData)
        this->_initGenFakeHashData();
}

void DYBackEnd::receiveFromQml(QVariantMap dSignal)
{
    qDebug() << "backend received dSignal: \n" << dSignal;
    qDebug() << "sigId:" << dSignal["sigId"].toString();
}

QVariant DYBackEnd::getHashDataObj(QStringList dataIdList)
{
    QVariantMap dataObj;
    for(int i=0; i<dataIdList.length(); i++){
        dataObj[dataIdList.at(i)] = _dyHash.value(dataIdList.at(i));
    }
    return dataObj;
}

QVariantList DYBackEnd::getHashDataList(QStringList dataIdList)
{
    QVariantList dataList;
    for(int i=0; i<dataIdList.length(); i++){
        QVariantMap data = _dyHash.value(dataIdList.at(i));
        dataList.append(data);
    }
    return dataList;
}

QVariant DYBackEnd::getHashData(QString dataId)
{
    return _dyHash.value(dataId);
}

QVariant DYBackEnd::getHashDataItem(QString dataId, QString itemName)
{
    QVariantMap data = _dyHash.value(dataId);
    if(data.isEmpty())
        qDebug() << "not find data of " << dataId;
    else
        if(!_dataItems.contains(itemName))
            qDebug() << "find data of " << dataId
            << ", but the data contains no itemName of " << itemName;
    return data[itemName];
}


void DYBackEnd::initTestTriggerGui(){
    testTriggerGUI *triggerGUI = new testTriggerGUI(this->_engine, this);
}

void DYBackEnd::_initGenFakeHashData()
{
    GenFakeHashData *genFakeData = new GenFakeHashData(&_dyHash, this);
    genFakeData->startGenData();
}
