#ifndef ABSTRACT_CORE_H
#define ABSTRACT_CORE_H

#include "core_export.h"

#include <QDir>
#include <QObject>
#include <QPluginLoader>
#include <QPointer>
#include <QSettings>
#include <QQmlApplicationEngine>

namespace Core {
    /*!
     * \brief Класс для загрузки плагинов и подготовки их к использованию
     */
    class CORE_EXPORT AbstractCore : public QObject
    {
        Q_OBJECT

    public:
        static AbstractCore &instance()
        {
            static AbstractCore core;
            return core;
        }

        /*!
         * \brief В методе реализована логика предоставления прямого доступа к каждому плагину,
         * лежащему в папке ../plugins. Указатели на root component каждого плагина добавляются в
         * список(QList<QPointer<QObject>> _plugins)
         * \param path - в этой строке находится путь до папки plugins
         */
        bool loadPlugins(const QString &path);

        /*!
         * \brief Метод присваивает переданному указателю адрес памяти, где находится плагин
         * \param objects - плагины, среди которых нужно искать
         * \param iface - указатель внутри класса плагина
         * \return True если плагин найден, иначе false
         */
        template<typename Interface>
        bool resolve(const QList<QPointer<QObject>> &objects, QPointer<Interface> &iface)
        {
            for (QPointer<QObject> object : objects)
                if (iface = qobject_cast<Interface *>(object); iface)
                    return true;

            return false;
        }

        /*!
         * \brief Метод принмает все зависимоти в виде QObject и плагины, к которым
         * нужно првоерить (скастовать) зависимости
         * \param dependencies - плагинные зависимости
         * \param plugin - проверяемые плагин/ы
         * \param plugins - проверяемые плагин/ы
         * \return true - в случае если зависимости были успешно установлены,
         * else - если не удалость найти плагин/ны
         */
        template<typename T, typename... R>
        bool resolve(const QList<QPointer<QObject>> &dependencies, T *&plugin, R *&...plugins)
        {
            return resolve(dependencies, plugin) && resolve(dependencies, plugins...);
        }

        /*!
         * \brief Метод возвращает указатель на engine.
         * \return Указатель на engine.
         */
        const QPointer<QQmlApplicationEngine> engine() const;

        /*!
         * \brief Метод возвращает указатель на QSettings.
         * \return Указатель на QSetings.
         */
        const QPointer<QSettings> settings() const;

        /*!
         * \brief plugins - метод возвращает список плагинов, загруженных из папки plugins
         */
        const QList<QPointer<QObject>> plugins() const;

    private:
        /*!
         * \brief Реализация патерна Singleton
         */
        explicit AbstractCore();
        virtual ~AbstractCore() = default;
        AbstractCore(const AbstractCore &) = delete;
        AbstractCore &operator=(AbstractCore) = delete;

        /*!
         * \brief Список плагинов, которые будут загружены из папки plugins
         */
        QList<QPointer<QObject>> _plugins;

        /*!
         * \brief Указатель на QSettings
         */
        QPointer<QSettings> _settings { nullptr };

        /**
         * \brief _engine
         */
        QPointer<QQmlApplicationEngine> _engine { nullptr };
    };
}

#endif // ABSTRACT_CORE_H
