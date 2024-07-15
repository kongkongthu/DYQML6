#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQmlContext>
#include "./C++/guifileloader.h"
#include "./C++/dybackend.h"

int main(int argc, char *argv[])
{
//    QGuiApplication app(argc, argv);
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DYBackEnd* backend = new DYBackEnd(true, &engine);
    engine.rootContext()->setContextProperty("backend", backend);

    GuiFileLoader* fileLoader = backend->getGUILoader();
    engine.rootContext()->setContextProperty("fileLoader", fileLoader);


    const QUrl url(u"qrc:/DYQML6/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    fileLoader->tryDefaultFile();
    backend->initTestTriggerGui();


    return app.exec();
}
