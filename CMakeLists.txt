cmake_minimum_required(VERSION 3.15)

project(dearimgui LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(${PROJECT_NAME} STATIC)

# +++++++++++++++++++++++++++++++++++++++
# add extra source
set(SOURCES "")

set(SOURCE_DIR
        ${CMAKE_CURRENT_SOURCE_DIR}/extension
        ${CMAKE_CURRENT_SOURCE_DIR}/extension/widgets
)

foreach(DIR ${SOURCE_DIR})
    if(APPLE)
        file(GLOB GLOB_SOURCES ${DIR}/*.mm)
        list(APPEND SOURCES ${GLOB_SOURCES})
    endif()
    file(GLOB GLOB_SOURCES ${DIR}/*.c ${DIR}/*.cpp ${DIR}/*.h ${DIR}/*.sc ${DIR}/*.inl)
    list(APPEND SOURCES ${GLOB_SOURCES})
endforeach ()

MESSAGE(STATUS ${SOURCES})

# +++++++++++++++++++++++++++++++++++++++

target_sources(
    ${PROJECT_NAME}
    PRIVATE
        imgui/imgui.cpp
        imgui/imgui_demo.cpp
        imgui/imgui_draw.cpp
        imgui/imgui_widgets.cpp
        imgui/imgui_tables.cpp
        imgui/misc/cpp/imgui_stdlib.cpp
        imgui/misc/freetype/imgui_freetype.cpp
        ${SOURCES}
)

include(GNUInstallDirs)

target_link_libraries(${PROJECT_NAME} PRIVATE freetype)

target_include_directories(
    ${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/imgui>
                           $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_include_directories(${PROJECT_NAME} PRIVATE ${SOURCE_DIR})
target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/include/freetype
)

target_compile_definitions(
    ${PROJECT_NAME}
    PUBLIC
        IMGUI_DISABLE_INCLUDE_IMCONFIG_H
        IMGUI_INCLUDE_IMGUI_USER_H
        IMGUI_INCLUDE_IMGUI_USER_INL
        BX_CONFIG_DEBUG=0
        $<$<BOOL:${IMGUI_DISABLE_OBSOLETE_FUNCTIONS}>:IMGUI_DISABLE_OBSOLETE_FUNCTIONS>
)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_11)

set_target_properties(${PROJECT_NAME} PROPERTIES
        DEBUG_POSTFIX "d"
)

install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}-config
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(
    EXPORT ${PROJECT_NAME}-config
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

install(FILES
        imgui/imgui.h
        imgui/imconfig.h
        imgui/misc/cpp/imgui_stdlib.h
        imgui/imgui_internal.h
        imgui/imstb_textedit.h
        imgui/misc/freetype/imgui_freetype.h
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/dearimgui)

install(DIRECTORY ${SOURCE_DIR}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/dearimgui
        FILES_MATCHING
        PATTERN "*.h"
        PATTERN "*.inl"
)
