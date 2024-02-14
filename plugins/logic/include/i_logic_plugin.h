#ifndef I_LOGIC_PLUGIN_H
#define I_LOGIC_PLUGIN_H

#include "logic_plugin_export.h"
#include "logic_interface.h"

#include <abstract_core.h>

namespace LogicPlugin {
    /*!
     * \brief Класс реализующий плагин бизнес-логики
     */
    class __declspec(dllexport) ILogicPlugin : public Core::LogicInterface
    {
        Q_OBJECT

        /*!
         * \brief Этот макрос сообщает Qt, какие интерфейсы реализует класс. Это
         * используется при внедрении плагинов.
         */
        Q_INTERFACES(Core::LogicInterface)

        virtual int multiply(int a, int b) = 0;
    };
}
Q_DECLARE_INTERFACE(LogicPlugin::ILogicPlugin,
                    "com.LogicPlugin.ILogicPlugin")

#endif // I_LOGIC_PLUGIN_H
