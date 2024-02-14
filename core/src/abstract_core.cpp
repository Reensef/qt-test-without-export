#include "abstract_core.h"
#include "base_interface.h"
#include <QCoreApplication>

namespace Core {
    bool AbstractCore::loadPlugins(const QString &path)
    {
        QDir dir(path);

        if (!dir.exists())
            return false;

        QStringList plugins;

#ifdef Q_OS_WIN
        plugins = dir.entryList(QStringList("*.dll"), QDir::Files);
#elif defined Q_OS_UNIX
        plugins = dir.entryList(QStringList("*.so"), QDir::Files);
#endif
        for (const auto &plugin : qAsConst(plugins)) {
            QPluginLoader loader;
            loader.setFileName(path + "/" + plugin);

            const auto loadingInstance = qobject_cast<QObject *>(loader.instance());

            if (loadingInstance) {
                qInfo() << Q_FUNC_INFO << "Plugin loaded";
            } else {
                qWarning() << Q_FUNC_INFO << loader.errorString();
                return false;
            }

            if (const auto plugin = qobject_cast<BaseInterface *>(loadingInstance); plugin) {
                _plugins.push_back(plugin);
            }
        }

        for (const auto &plugin : qAsConst(_plugins)) {
            const auto p = qobject_cast<BaseInterface *>(plugin.data());
            if (!p->initialize(_plugins)) {
                qInfo() << Q_FUNC_INFO << "Initialize " << plugin << " failed";
                return false;
            }
        }

        qInfo() << Q_FUNC_INFO << "Plugins: " << _plugins << " initialized";

        return true;
    }

    AbstractCore::AbstractCore()
    {
        _engine = new QQmlApplicationEngine(this);
        _settings =
         new QSettings("notification_manager_settings", QSettings::Format::IniFormat, this);
    }

    const QPointer<QQmlApplicationEngine> AbstractCore::engine() const
    {
        return _engine;
    }

    const QPointer<QSettings> AbstractCore::settings() const
    {
        return _settings;
    }

    const QList<QPointer<QObject>> AbstractCore::plugins() const
    {
        return _plugins;
    }

} // namespace Core
