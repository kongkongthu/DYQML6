#ifndef GENFAKEHASHDATA_H
#define GENFAKEHASHDATA_H

#include <QObject>
#include <QHash>
#include <QVariantHash>
#include <QTimer>
#include <QRandomGenerator>


class GenFakeHashData : public QObject
{
    Q_OBJECT
public:
    GenFakeHashData(QHash<QString, QVariantMap> *dyHash, QObject *parent=nullptr);
    void startGenData();

private:
    QHash<QString, QVariantMap> *_dyHash;
    QTimer* _genTimer;

public slots:
    void gengerating();

};

#endif // GENFAKEHASHDATA_H
