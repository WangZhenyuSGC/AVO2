
#ifndef AVO_EXPORT_H
#define AVO_EXPORT_H

#ifdef AVO_STATIC_DEFINE
#  define AVO_EXPORT
#  define AVO_NO_EXPORT
#else
#  ifndef AVO_EXPORT
#    ifdef AVO_EXPORTS
        /* We are building this library */
#      define AVO_EXPORT __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define AVO_EXPORT __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef AVO_NO_EXPORT
#    define AVO_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef AVO_DEPRECATED
#  define AVO_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef AVO_DEPRECATED_EXPORT
#  define AVO_DEPRECATED_EXPORT AVO_EXPORT AVO_DEPRECATED
#endif

#ifndef AVO_DEPRECATED_NO_EXPORT
#  define AVO_DEPRECATED_NO_EXPORT AVO_NO_EXPORT AVO_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef AVO_NO_DEPRECATED
#    define AVO_NO_DEPRECATED
#  endif
#endif

#endif /* AVO_EXPORT_H */
