#ifndef GUI_PLUGIN_H
#define GUI_PLUGIN_H

#include "i_gui_plugin.h"

#include <QObject>
#include <QString>
#include <QtQuick>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QVariantMap>
#include <QDebug>
#include <QtCore/QMetaType>
#include <QtMultimedia/QSound>

namespace GuiPlugin {
    class GuiPlugin final : public IGuiPlugin
    {
        Q_OBJECT

        /*!
         * \brief Q_INTERFACES Этот макрос сообщает Qt, какие интерфейсы реализует класс. Это
         * используется при внедрении плагинов.
         */
        Q_INTERFACES(GuiPlugin::IGuiPlugin)

        /*!
         * \brief Q_PLUGIN_METADATA  Этот макрос используется для объявления метаданных, которые
         * являются частью плагина, создающего экземпляр этого объекта. Макрос должен объявить IID
         * интерфейса, реализованного через объект, и сослаться на файл, содержащий метаданные для
         * плагина.
         */
        Q_PLUGIN_METADATA(IID "com.GuiPlugin" FILE "metadata.json")

    public:
        /*!
         * \copydoc BaseInterface::initialize(const QList<QPointer<QObject>>)
         */
        bool initialize(const QList<QPointer<QObject>> &dependencies) override;
    };
}
#endif // GUI_PLUGIN_H
