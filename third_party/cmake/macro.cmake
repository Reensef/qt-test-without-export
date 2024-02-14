macro(PARSE_SUBDIRECTORIES)
    foreach(arg IN ITEMS ${ARGN})
        add_subdirectory(${arg})
    endforeach()
endmacro()

macro(AUTO_BUILD_RESOURCES_QT5)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)
    set(CMAKE_AUTOUIC ON)
endmacro()

macro(SET_BASE_TARGET_PROPERTIES TARGET)
    set_target_properties(
            ${TARGET} PROPERTIES
            CXX_STANDARD 20
            CXX_STANDARD_REQUIRED ON
    )
endmacro()

# Макрос конвертирует файлы с расширением .ts в .qm
# TARGET - цель, после которой произойдет конвертация
# IN - директория с файлами .ts
# OUT - директория с файлами .qm
macro(TS_TO_QM TARGET IN OUT)
    file(GLOB_RECURSE PRE_TRANSLATIONS ${IN}/*.ts)

    foreach(PRE_TRANSLATION IN ITEMS ${PRE_TRANSLATIONS})
        get_filename_component(TRANSLATIONS_NAME ${PRE_TRANSLATION} NAME_WE)

        if(WIN32)
            set(EXE .exe)
        endif()

        add_custom_command(TARGET ${TARGET} POST_BUILD
            COMMAND ${CMAKE_PREFIX_PATH}/bin/lrelease${EXE} ${PRE_TRANSLATION} -qm ${OUT}/${TRANSLATIONS_NAME}.qm
            COMMENT "Command for release translations")
    endforeach()
endmacro()

# Макрос ищет указанные в аргументах компоненты QT линкует их с таргетом
# TARGET - цель, к которой будут линковаться Qt компоненты
# QT_COMPONENTS - Qt компоненты
macro(FIND_AND_LINK_QT)
    set(_OPTIONS_ARGS)
    set(_ONE_VALUE_ARGS TARGET)
    set(_MULTI_VALUE_ARGS QT_COMPONENTS)

    # Парсим все переданные аргументы в модуль
    cmake_parse_arguments(_LIBS_LINKING
        "${_OPTIONS_ARGS}"
        "${_ONE_VALUE_ARGS}"
        "${_MULTI_VALUE_ARGS}"
        ${ARGN})

    if (NOT _LIBS_LINKING_TARGET)
        message(FATAL_ERROR "FIND_AND_LINK_QT : TARGET is not set")
    endif()

    if (NOT _LIBS_LINKING_QT_COMPONENTS)
        message(FATAL_ERROR "FIND_AND_LINK_QT : QT_COMPONENTS is not set")
    endif()

    # Ищем пакеты Qt6 или Qt5
    find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS ${_LIBS_LINKING_QT_COMPONENTS})

    # Ищем нужные компоненты
    find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS ${_LIBS_LINKING_QT_COMPONENTS})

    foreach(COMPONENT ${_LIBS_LINKING_QT_COMPONENTS})
        message(STATUS "LINK - ${_LIBS_LINKING_TARGET}
            Qt${QT_VERSION_MAJOR}::${COMPONENT}")
        target_link_libraries(
                ${_LIBS_LINKING_TARGET}
                PRIVATE
                Qt${QT_VERSION_MAJOR}::${COMPONENT}
        )
    endforeach()
endmacro()

# Макрос ищет все исходники в проекте и формирует группы из них
# TARGET - цель, для которой будут собраны группы исходников
macro(INCLUDE_SOURCES TARGET)
    set(_OPTIONS_ARGS NOT_RECURSIVE)
    set(_ONE_VALUE_ARGS DIR)
    set(_MULTI_VALUE_ARGS EXCLUDE_LIST)

    cmake_parse_arguments(_INCLUDE_SOURCES
        "${_OPTIONS_ARGS}"
        "${_ONE_VALUE_ARGS}"
        "${_MULTI_VALUE_ARGS}"
        ${ARGN})

    if (NOT _INCLUDE_SOURCES_DIR)
        set(_INCLUDE_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    if (_INCLUDE_SOURCES_NOT_RECURSIVE)
        set(RECURSIVE_FLAG GLOB)
    else()
        set(RECURSIVE_FLAG GLOB_RECURSE)
    endif()

    # Ищем исходники в подпроекте, исходя из переменной DIR
    file(${RECURSIVE_FLAG} HEADERS ${_INCLUDE_SOURCES_DIR}/*.h)
    file(${RECURSIVE_FLAG} SOURCES ${_INCLUDE_SOURCES_DIR}/*.cpp *.cc)
    file(${RECURSIVE_FLAG} RESOURCES ${_INCLUDE_SOURCES_DIR}/*.qrc)
    file(${RECURSIVE_FLAG} MANIFESTS ${_INCLUDE_SOURCES_DIR}/*.rc README.txt)
    file(${RECURSIVE_FLAG} METADATA ${_INCLUDE_SOURCES_DIR}/*.json)
    file(${RECURSIVE_FLAG} UI_FILES ${_INCLUDE_SOURCES_DIR}/*.ui)

    # Исключаем файлы, которые были переданы в EXCLUDE_LIST
    foreach(EXCLUDE_FILE ${_INCLUDE_SOURCES_EXCLUDE_LIST})
        set(REGEX "^(.*)${EXCLUDE_FILE}(.*)$")
        list(FILTER HEADERS EXCLUDE REGEX ${REGEX})
        list(FILTER SOURCES EXCLUDE REGEX ${REGEX})
        list(FILTER RESOURCES EXCLUDE REGEX ${REGEX})
        list(FILTER MANIFESTS EXCLUDE REGEX ${REGEX})
        list(FILTER METADATA EXCLUDE REGEX ${REGEX})
        list(FILTER UI_FILES EXCLUDE REGEX ${REGEX})
    endforeach()

    # Выделяем группу исходников (для отображения в IDE)
    source_group("Header Files" FILES ${HEADERS})
    source_group("Source Files" FILES ${SOURCES})
    source_group("Resources" FILES ${RESOURCES})
    source_group("Manifests" FILES ${MANIFESTS})
    source_group("Proto Files" FILES ${PROTOS})
    source_group("Metadata Files" FILES ${METADATA})
    source_group("UI Files" FILES ${UI_FILES})

    message(STATUS "SOURCES - configured for ${TARGET}")
endmacro()

# Макрос генерирует заголовочные файлы экспорта и добаляет их в указанную
# директорию
# TARGET - цель, для которой будет происходить генерация
# DIR - директория, в которую будут генерироваться файлы
macro(GENERATE_EXPORT_HEADERS)
    set(_OPTIONS_ARGS)
    set(_ONE_VALUE_ARGS TARGET DIR)

    # Парсим все переданные аргументы в модуль
    cmake_parse_arguments(_HEADER_GENERATOR
        "${_OPTIONS_ARGS}"
        "${_ONE_VALUE_ARGS}"
        "${_MULTI_VALUE_ARGS}"
        ${ARGN})

    if (NOT _HEADER_GENERATOR_TARGET)
        message(FATAL_ERROR "GENERATE_EXPORT_HEADERS : TARGET is not set")
    endif()

    if (NOT _HEADER_GENERATOR_DIR)
        message(FATAL_ERROR "GENERATE_EXPORT_HEADERS : DIR is not set")
    endif()

    include(GenerateExportHeader)
    generate_export_header(${_HEADER_GENERATOR_TARGET}
        EXPORT_FILE_NAME
        ${_HEADER_GENERATOR_DIR}/${_HEADER_GENERATOR_TARGET}_export.h)
    message(STATUS "EXPORT HEADER - generated for ${_HEADER_GENERATOR_TARGET}")
endmacro()

# Макрос генерирует метадату для плагина
# TARGET - цель, для которой будет генерироваться метадата
macro(PLUGIN_METADATA_GENERATOR TARGET)
    set(_ONE_VALUE_ARGS
        NAME
        VERSION
        COMPAT_VERSION
        VENDOR
        COPYRIGHT
        LICENSE
        CATEGORY
        DESCRIPTION
        URL)

    set(_MULTI_VALUE_ARGS DEPENDENCIES)

    cmake_parse_arguments(_METADATA
        "${_OPTIONS_ARGS}"
        "${_ONE_VALUE_ARGS}"
        "${_MULTI_VALUE_ARGS}"
        ${ARGN})

    foreach(DEP ${_METADATA_DEPENDENCIES})
        string(REPLACE " " ";" CURR_DEP ${DEP})
        list(GET CURR_DEP 0 DEP_NAME)
        list(GET CURR_DEP 1 DEP_VERSION)

        list(APPEND TEMP_LIST
        "{\"Name\" : \"${DEP_NAME}\", \"Version\" : \"${DEP_VERSION}\"}")
    endforeach()

    string(REPLACE ";" ",\n        " DEPENDENCIES_JSON_FORMAT "${TEMP_LIST}")

    configure_file(${CMAKE_CURRENT_LIST_DIR}/../metadata.json.in
    ${CMAKE_CURRENT_LIST_DIR}/include/metadata.json)

    message(STATUS "METADATA - generated for ${TARGET}")
endmacro()

# Макрос отвечает за формирование модуля тестирования
# TEST_NAME - имя теста
# DEPENDS - нужные библиотеки, которые будут залинкованы
# OPTIONAL_DEPENDS - опциональные зависимости
# GOOGLE_TEST - флаг, который регулирует включение или отключение Google тестов
macro(TEST)
    set(_OPTIONS_ARGS)
    set(_ONE_VALUE_ARGS)
    set(_MULTI_VALUE_ARGS TEST_NAME DEPENDS OPTIONAL_DEPENDS GOOGLE_TEST)

    # Парсим все переданные аргументы в модуль
    cmake_parse_arguments(_TEST
        "${_OPTIONS_ARGS}"
        "${_ONE_VALUE_ARGS}"
        "${_MULTI_VALUE_ARGS}"
        ${ARGN})

    # Если не задано имя модуля - ошибка
    if (NOT _TEST_TEST_NAME)
        message(FATAL_ERROR "GUARD_TEST: 'TEST_NAME' argument required")
    endif()

    project(${_TEST_TEST_NAME})

    message(STATUS "START CONFIGURED GUARD_TEST ${_TEST_TEST_NAME}")

    # Формируем автоматическую сборку файлов для qt5
    AUTO_BUILD_RESOURCES_QT5()

    # Если есть зависимости, то проходимся по списку и ищем их
    foreach(DEPEND ${_TEST_DEPENDS})
        find_package(${DEPEND} REQUIRED)
    endforeach()

    # Ищем и формируем исходники теста
    INCLUDE_SOURCES(${_TEST_TEST_NAME})

    QT5_ADD_RESOURCES(PLUGIN_RESOURCES ${RESOURCES})

    # Если есть хоть что-то для создания библиотеки и бинарника для теста
    if (HEADERS OR SOURCES OR PLUGIN_RESOURCES OR MANIFESTS)
        # Создаём бинарник тестов
        add_executable(${_TEST_TEST_NAME} ${SOURCES} ${HEADERS} ${PLUGIN_RESOURCES} $<TARGET_OBJECTS:logic_plugin_obj>)
        add_test(${_TEST_TEST_NAME} ${_TEST_TEST_NAME})

        # Добавление директории сорцов к модулю
        target_include_directories(${_TEST_TEST_NAME} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/src)
    endif()

    # Задаём путь куда будет собрана библиотека
    INSTALL_PREFIX(TARGET_NAME ${_TEST_TEST_NAME} CATEGORY "tests")

    target_sources(${_TEST_TEST_NAME} PUBLIC ${RESOURCES})

    # Линковка всех зависимостей
    foreach(DEPEND ${_TEST_DEPENDS})
        # Выставляем переменную библиотеки, которую надо залинковать
        set(LIBS ${${DEPEND}_LIBRARIES})

        # Если переменная не выставилась (зависимость не найдена)
        if(NOT LIBS)
            message(FATAL_ERROR "DEPEND ${DEPEND}: empty ${DEPEND}_LIBRARIES var")
        endif()

        # Линкуем библиотеку с зависимостью
        target_link_libraries(${_TEST_TEST_NAME} PUBLIC ${${DEPEND}_LIBRARIES})

        message(STATUS "${${DEPEND}_LIBRARIES} HAS BEEN LINKED FOR ${_TEST_TEST_NAME}")
    endforeach()

    foreach(OPTIONAL_DEPEND ${_TEST_OPTIONAL_DEPENDS})
        # Линкуем библиотеку с зависимостью
        target_link_libraries(${_TEST_TEST_NAME} PUBLIC ${OPTIONAL_DEPEND})

        message(STATUS "${OPTIONAL_DEPEND} HAS BEEN LINKED FOR ${_TEST_TEST_NAME}")
    endforeach()

    if (_TEST_GOOGLE_TEST)
        find_package(GTest REQUIRED)

        include_directories(${GTEST_INCLUDE_DIRS})

        gtest_discover_tests(${_TEST_TEST_NAME})

        target_link_libraries(${_TEST_TEST_NAME} PRIVATE ${GTEST_LIBRARIES} pthread)
    endif()

    add_custom_command(TARGET ${_TEST_TEST_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${_TEST_TEST_NAME}> $<TARGET_FILE_DIR:${_TEST_TEST_NAME}> COMMAND_EXPAND_LISTS)

    message(STATUS "FINISH CONFIGURED GUARD_TEST ${_TEST_TEST_NAME}\n")
endmacro()

# Макрос позволяет задать выходные пути куда будут положены бинарники, библиотеки и т.д.
# и выставить их для таргета
# TARGET_NAME - имя таргета, для которого выставляется путь
# CATEGORY - категория для таргета
# CUSTOM_PATH - опционально для QML
# CUSTOM_ARCHIVE_OUTPUT_DIRECTORY - путь, который будет выставлен для ARCHIVE_OUTPUT_DIRECTORY
# CUSTOM_LIBRARY_OUTPUT_DIRECTORY - путь, который будет выставлен для LIBRARY_OUTPUT_DIRECTORY
# CUSTOM_RUNTIME_OUTPUT_DIRECTORY - путь, который будет выставлен для RUNTIME_OUTPUT_DIRECTORY
macro(INSTALL_PREFIX)
    set(_OPTIONS_ARGS)
    set(_ONE_VALUE_ARGS)
    set(_MULTI_VALUE_ARGS
        TARGET_NAME
        CATEGORY
        CUSTOM_PATH
        CUSTOM_ARCHIVE_OUTPUT_DIRECTORY
        CUSTOM_LIBRARY_OUTPUT_DIRECTORY
        CUSTOM_RUNTIME_OUTPUT_DIRECTORY
    )
endmacro()
