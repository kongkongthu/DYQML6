#include "guifileloader.h"

GuiFileLoader::GuiFileLoader(QObject *parent) : QObject(parent)
{}

void GuiFileLoader::jsonHasChosen(QString jsonPath)
{
    qDebug() << "json path: " << jsonPath;
    this->jsonFilePath = jsonPath.mid(8);
    this->readJsonFile();
}

void GuiFileLoader::reloadGUI()
{
    this->readJsonFile();
}

void GuiFileLoader::tryDefaultFile()
{
    QDir qd(this->_defaultPath);
    QFileInfoList subFileList = qd.entryInfoList(QDir::Files | QDir::CaseSensitive);
    QStringList jsonFileList;
    for(int i=0; i<subFileList.length(); i++){
        QString suffix = subFileList[i].suffix();
        if(suffix=="json" || suffix=="JSON")
            jsonFileList << subFileList[i].filePath();
    }
    if(jsonFileList.length()>0){
        this->jsonFilePath = jsonFileList.at(0);
        this->readJsonFile();
    }
}

void GuiFileLoader::readJsonFile(){
    QFile jsonFile(this->jsonFilePath);
    if(!jsonFile.open(QIODevice::ReadOnly)){
        qDebug() << "Something wrong with the json file. It can not be read correctly."
                 << __FILE__
                 << "jsonFilePath:"
                 << this->jsonFilePath;
        return;
    }
    QByteArray jsonData = jsonFile.readAll();
    jsonFile.close();

    QJsonParseError parseError;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(jsonData, &parseError));
    if(parseError.error != QJsonParseError::NoError){
        qDebug() << "json parse error: " << parseError.errorString();
        return;
    }
    QJsonObject jsonObj = jsonDoc.object();
    this->jsonInfoStr = QString(jsonDoc.toJson());
//    qDebug() << "json info:" << this->jsonInfoStr;
    emit jsonHasRead(this->jsonInfoStr);
    qDebug() << "has emitted jsonHasRead signal";
}
