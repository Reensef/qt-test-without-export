#include "application.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QFile>
#include <QtPlugin>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
    QGuiApplication app(argc, argv);

    app.setQuitOnLastWindowClosed(false);

    QString pluginsDir = QGuiApplication::applicationDirPath() + "/plugins";

    App::Application pluginInvoker;

    pluginInvoker.invokePluginsLoading(pluginsDir);

    return app.exec();
}
