set(PROJECT_NAMESPACE qt_plugins_structure)

add_library(compilation_flags INTERFACE)
add_library(${PROJECT_NAMESPACE}::compilation_flags ALIAS compilation_flags)

target_compile_options(compilation_flags
    INTERFACE
        -Werror
        -pedantic-errors
        -Wall
        -Wextra
        -Wpedantic
        -Wcast-align
        -Wcast-qual
        -Wconversion
        -Wctor-dtor-privacy
        -Wduplicated-branches
        -Wduplicated-cond
        -Wextra-semi
        -Wfloat-equal
        -Wlogical-op
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Woverloaded-virtual
        -Wredundant-decls
        -Wsign-conversion
        -Wsign-promo
)

cmake_minimum_required(VERSION 3.24)

project(qt_plugins-structure
    VERSION 0.0.1
    LANGUAGES CXX)


include(${CMAKE_CURRENT_SOURCE_DIR}/third_party/cmake/base.cmake)

AUTO_BUILD_RESOURCES_QT5()

file(
    COPY ${CMAKE_PREFIX_PATH}/qml
    DESTINATION ${CMAKE_BINARY_DIR}/install-root
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

PARSE_SUBDIRECTORIES(
    app
    core
    plugins
    translations)
