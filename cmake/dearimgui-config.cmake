include(CMakeFindDependencyMacro)

MESSAGE(STATUS ">>>>>>>>" "$ENV{CMAKE_INSTALL_PREFIX}")
find_dependency(freetype HINTS "$ENV{CMAKE_INSTALL_PREFIX}")
MESSAGE("Freetype found: " ${freetype_FOUND})


include("${CMAKE_CURRENT_LIST_DIR}/dearimguiTargets.cmake")