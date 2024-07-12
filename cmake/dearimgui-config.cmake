include(CMakeFindDependencyMacro)

find_dependency(freetype HIT "$ENV{CMAKE_INSTALL_PREFIX}")

include("${CMAKE_CURRENT_LIST_DIR}/dearimguiTargets.cmake")