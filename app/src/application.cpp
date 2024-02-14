#include "application.h"

App::Application::Application()
{}

void App::Application::invokePluginsLoading(const QString &pluginsDir)
{
    Core::AbstractCore::instance().loadPlugins(pluginsDir);
}
