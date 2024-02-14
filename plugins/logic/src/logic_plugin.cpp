#include "logic_plugin.h"

#include <QDebug>

namespace LogicPlugin {
    bool LogicPlugin::initialize(const QList<QPointer<QObject>> &dependencies)
    {
        qDebug() << "Plugin was initialize" << dependencies;
        return true;
    }

    int LogicPlugin::multiply(int a, int b)
    {
        return a * b;
    }
}
