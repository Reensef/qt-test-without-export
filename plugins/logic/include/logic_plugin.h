#ifndef LOGIC_PLUGIN_H
#define LOGIC_PLUGIN_H

#include "i_logic_plugin.h"

#include <QString>
#include <QTimer>
#include <QObject>
#include <QQuickWindow>

namespace LogicPlugin {
    /*!
     * \brief Класс реализующий плагин бизнес-логики
     */
    class LogicPlugin final : public ILogicPlugin
    {
        Q_OBJECT

        /*!
         * \brief Q_INTERFACES Этот макрос сообщает Qt, какие интерфейсы реализует класс. Это
         * используется при внедрении плагинов.
         */
        Q_INTERFACES(LogicPlugin::ILogicPlugin)

        /*!
         * \brief Q_PLUGIN_METADATA Этот макрос используется для объявления метаданных, которые
         * являются частью плагина, создающего экземпляр этого объекта. Макрос должен объявить IID
         * интерфейса, реализованного через объект, и сослаться на файл, содержащий метаданные для
         * плагина.
         */
        Q_PLUGIN_METADATA(IID "com.LogicPlugin.ILogicPlugin" FILE "metadata.json")

    public:
        /*!
         * \copydoc BaseInterface::initialize(const QList<QPointer<QObject>> &dependencies)
         */
        bool initialize(const QList<QPointer<QObject>> &dependencies) override;

        int multiply(int a, int b) override;
    };
}

#endif // LOGIC_PLUGIN_H
