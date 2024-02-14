#ifndef APPLICATION_H
#define APPLICATION_H

// #include <i_logic_plugin.h>
#include <i_gui_plugin.h>

#include <abstract_core.h>
#include <QDir>
#include <QTimerEvent>

namespace App {
    /*!
     * \brief Класс, используемый для создания сущности, при помощи которой вызывается метод
     * загрузки плагинов
     */
    class Application : public QObject
    {
        Q_OBJECT

    public:
        explicit Application();
        ~Application() = default;

        /*!
         * \brief Метод, вызывающий метод загрузки плагинов
         * \param pluginsDir - переменная, указывающая на каталог с плагинами
         */
        void invokePluginsLoading(const QString &pluginsDir);

    private:
        /*!
         * \brief _logicPlugin
         */
        // QPointer<LogicPlugin::ILogicPlugin> _logicPlugin;

        /*!
         * \brief _logicPlugin
         */
        QPointer<GuiPlugin::IGuiPlugin> _guiPlugin;
    };
}
#endif // APPLICATION_H
