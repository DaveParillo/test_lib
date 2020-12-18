cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

project(
  lib_echo
  VERSION 1.0.0
  LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH 
    ${CMAKE_MODULE_PATH}
    ${CMAKE_CURRENT_LIST_DIR}/cmake
)

include(./cmake/default-settings.cmake)
include(./cmake/packaging.cmake)

add_subdirectory(lib/echo)
add_subdirectory(lib/async)

################
#   Packaging
################

# General metadata
set(CPACK_RPM_PACKAGE_SUMMARY "echo library")

include (CPack)

