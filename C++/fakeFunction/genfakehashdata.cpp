#include "genfakehashdata.h"

GenFakeHashData::GenFakeHashData(QHash<QString, QVariantMap> *dyHash, QObject *parent)
{
    this->_dyHash = dyHash;
}

void GenFakeHashData::startGenData()
{
    this->_genTimer = new QTimer(this);
    this->connect(this->_genTimer, SIGNAL(timeout()), this, SLOT(gengerating()));
    this->_genTimer->start(200);
}

void GenFakeHashData::gengerating()
{
    QString rawDataId = "fake-data-guid";
    QString dataId;
    QString valueName;
    QString unit = "m";
    double value;
    QVariantMap dataInfo;

    for (int i = 0; i < 100; ++i) {
        dataId = rawDataId + QString::number(i);
        valueName = "VName" + QString::number(i);
                    if(i % 4 == 1)
                    unit = "cm";
        else if(i % 4 == 2)
            unit = "º";
            else if(i % 4 == 3)
            unit = "℃";
        value = QRandomGenerator::global()->bounded(100.00);
        dataInfo["name"] = valueName;
        dataInfo["value"] = value;
        dataInfo["unit"] = unit;
        if(_dyHash->contains(dataId))
            _dyHash->remove(dataId);
        _dyHash->insert(dataId, dataInfo);
    }
}

