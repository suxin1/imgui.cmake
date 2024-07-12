include(CMakeFindDependencyMacro)

find_dependency(freetype HINTS "$ENV{CMAKE_INSTALL_PREFIX}")

include("${CMAKE_CURRENT_LIST_DIR}/dearimguiTargets.cmake")