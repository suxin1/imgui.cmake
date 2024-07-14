include(CMakeFindDependencyMacro)

MESSAGE(STATUS "cmake install prefix >> " ${CMAKE_INSTALL_PREFIX})
find_dependency(freetype HINTS "$ENV{CMAKE_INSTALL_PREFIX}")
MESSAGE(STATUS "freetype found status : " ${freetype_FOUND})

include("${CMAKE_CURRENT_LIST_DIR}/dearimguiTargets.cmake")