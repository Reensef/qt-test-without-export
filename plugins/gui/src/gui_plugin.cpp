#include "gui_plugin.h"

namespace GuiPlugin {
    bool GuiPlugin::initialize(const QList<QPointer<QObject>> &)
    {
        qDebug() << "Plugin was initialized";
        return true;
    }
}
