#ifndef I_GUI_PLUGIN_H
#define I_GUI_PLUGIN_H

#include "gui_plugin_export.h"
#include "gui_interface.h"

#include <abstract_core.h>

#include <QQuickWindow>
#include <QTranslator>

namespace GuiPlugin {
    /*!
     * \brief Класс реализующий плагин gui
     */
    class __declspec(dllexport) IGuiPlugin : public Core::GuiInterface
    {
        Q_OBJECT

        /*!
         * \brief Этот макрос сообщает Qt, какие интерфейсы реализует класс. Это
         * используется при внедрении плагинов.
         */
        Q_INTERFACES(Core::GuiInterface)
    };
}

Q_DECLARE_INTERFACE(GuiPlugin::IGuiPlugin, "com.LogicPlugin.IGuiPlugin")

#endif // I_GUI_PLUGIN_H
