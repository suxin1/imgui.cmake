cmake_minimum_required(VERSION 3.15)

project(dearimgui LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_IGNORE_PREFIX_PATH "/opt/homebrew" CACHE INTERNAL "")
set(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}:${CMAKE_SYSTEM_LIBRARY_PATH}" CACHE INTERNAL "")

add_library(${PROJECT_NAME} STATIC)

# Find dependencies
include(FindPkgConfig)

MESSAGE(STATUS ">>>>>>>>" "$ENV{CMAKE_INSTALL_PREFIX}")
find_package(freetype REQUIRED CONFIG CMAKE_FIND_ROOT_PATH_BOTH HINTS "$ENV{CMAKE_INSTALL_PREFIX}")
find_library(FT_LIBRARY NAMES freetype HINTS "$ENV{CMAKE_INSTALL_PREFIX}")
MESSAGE("Freetype found: " ${freetype_FOUND})
MESSAGE("Freetype found: " ${FT_LIBRARY})
MESSAGE("Freetype dir: " ${freetype_DIR})
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

# +++++++++++++++++++++++++++++++++++++++
add_compile_definitions(IMGUI_USER_CONFIG="imconfig_extra.h")

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
#if (freetype_FOUND)
#target_link_libraries(freetype PRIVATE ${freetype_LIBRARIES})
#target_compile_definitions(freetype PRIVATE ${freetype_DEFINITIONS})
#target_include_directories(freetype PRIVATE ${freetype_INCLUDE_DIRS})
#    MESSAGE(STATUS "freetype lib" ${freetype_LIBRARIES})
#    MESSAGE(STATUS "freetype lib" ${freetype_LIBRARY})
#    MESSAGE(STATUS "freetype def" ${freetype_DEFINITIONS})
#    MESSAGE(STATUS "freetype include" ${freetype_INCLUDE_DIRS})
#endif()

target_link_libraries(${PROJECT_NAME} PRIVATE freetype)

target_include_directories(
    ${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/imgui>
                           $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

target_include_directories(${PROJECT_NAME} PRIVATE ${SOURCE_DIR})
target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/extension
#        ${CMAKE_CURRENT_SOURCE_DIR}/include/freetype
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
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
        FILE dearimguiTargets.cmake
)

install(FILES
        imgui/imgui.h
#        imgui/imconfig.h
        imgui/misc/cpp/imgui_stdlib.h
        imgui/imgui_internal.h
        imgui/imstb_textedit.h
        imgui/misc/freetype/imgui_freetype.h
        extension/imgui_user.h
        extension/imgui_user.inl
        extension/imconfig_extra.h
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/dearimgui)

install(DIRECTORY ${SOURCE_DIR}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/dearimgui
        FILES_MATCHING
        PATTERN "*.h"
        PATTERN "*.inl"
)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/dearimgui-config.cmake DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})