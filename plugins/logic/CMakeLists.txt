project(
        logic_plugin
        VERSION 0.0.1
        LANGUAGES CXX
)

AUTO_BUILD_RESOURCES_QT5()

PLUGIN_METADATA_GENERATOR(
    ${PROJECT_NAME}
    NAME logic_plugin
    VERSION ${CMAKE_PROJECT_VERSION}
)

INCLUDE_SOURCES(${PROJECT_NAME})

set(QT_COMPONENTS
        Core Widgets
        QuickWidgets
        Core
        QuickControls2
        Sql
    )

add_library(
    "${PROJECT_NAME}_obj"
    OBJECT
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
    ${METADATA}
)

target_link_libraries("${PROJECT_NAME}_obj"
        PRIVATE
        ${PROJECT_NAMESPACE}::core
        ${PROJECT_NAMESPACE}::compilation_flags
)

FIND_AND_LINK_QT(TARGET ${PROJECT_NAME}_obj
    QT_COMPONENTS
    ${QT_COMPONENTS})

target_include_directories(${PROJECT_NAME}_obj
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

add_library(
    ${PROJECT_NAME}
    SHARED
    $<TARGET_OBJECTS:${PROJECT_NAME}_obj>
    # ${SOURCES}
    # ${HEADERS}
    # ${RESOURCES}
    # ${METADATA}
)

if(WIN32)
    set(OS_VAR_OUTPUT_DIRECTORY RUNTIME_OUTPUT_DIRECTORY)
else()
    set(OS_VAR_OUTPUT_DIRECTORY LIBRARY_OUTPUT_DIRECTORY)
endif()

set_target_properties(${PROJECT_NAME}
    PROPERTIES
    ${OS_VAR_OUTPUT_DIRECTORY} ${CMAKE_BINARY_DIR}/install-root/plugins
)

add_library(${PROJECT_NAMESPACE}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})


GENERATE_EXPORT_HEADERS(TARGET ${PROJECT_NAME} DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)


FIND_AND_LINK_QT(TARGET
    ${PROJECT_NAME}
    QT_COMPONENTS
    ${QT_COMPONENTS})

target_include_directories(${PROJECT_NAME}
        PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(${PROJECT_NAME}
        PRIVATE
        ${PROJECT_NAMESPACE}::core
        ${PROJECT_NAMESPACE}::gui_plugin
        ${PROJECT_NAMESPACE}::compilation_flags
)

SET_BASE_TARGET_PROPERTIES(${PROJECT_NAME})

