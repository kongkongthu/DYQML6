#ifndef GUIFILELOADER_H
#define GUIFILELOADER_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>
#include <QFile>
#include <QDir>
#include <QStringList>

class GuiFileLoader : public QObject
{
    Q_OBJECT
public:
    explicit GuiFileLoader(QObject *parent = nullptr);
    Q_INVOKABLE void jsonHasChosen(QString jsonPath);
    Q_INVOKABLE void reloadGUI();
    void tryDefaultFile();

private:
    QString jsonInfoStr;
    QString jsonFilePath;
    QString _defaultPath = QString("./Default");
    void readJsonFile();

signals:
    QString jsonHasRead(QString jsonStr);

public slots:
};

#endif // GUIFILELOADER_H
