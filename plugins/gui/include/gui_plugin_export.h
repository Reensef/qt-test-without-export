
#ifndef GUI_PLUGIN_EXPORT_H
#define GUI_PLUGIN_EXPORT_H

#ifdef GUI_PLUGIN_STATIC_DEFINE
#  define GUI_PLUGIN_EXPORT
#  define GUI_PLUGIN_NO_EXPORT
#else
#  ifndef GUI_PLUGIN_EXPORT
#    ifdef gui_plugin_EXPORTS
        /* We are building this library */
#      define GUI_PLUGIN_EXPORT __declspec(dllexport)
#    else
        /* We are using this library */
#      define GUI_PLUGIN_EXPORT __declspec(dllimport)
#    endif
#  endif

#  ifndef GUI_PLUGIN_NO_EXPORT
#    define GUI_PLUGIN_NO_EXPORT 
#  endif
#endif

#ifndef GUI_PLUGIN_DEPRECATED
#  define GUI_PLUGIN_DEPRECATED __declspec(deprecated)
#endif

#ifndef GUI_PLUGIN_DEPRECATED_EXPORT
#  define GUI_PLUGIN_DEPRECATED_EXPORT GUI_PLUGIN_EXPORT GUI_PLUGIN_DEPRECATED
#endif

#ifndef GUI_PLUGIN_DEPRECATED_NO_EXPORT
#  define GUI_PLUGIN_DEPRECATED_NO_EXPORT GUI_PLUGIN_NO_EXPORT GUI_PLUGIN_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef GUI_PLUGIN_NO_DEPRECATED
#    define GUI_PLUGIN_NO_DEPRECATED
#  endif
#endif

#endif /* GUI_PLUGIN_EXPORT_H */
