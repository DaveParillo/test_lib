cmake_minimum_required(VERSION 3.15)
project(test_async
    VERSION 1.0.0
)

find_package(RTIConnextDDS "5.3.1" REQUIRED)

include(GNUInstallDirs)
# hack to get 32bit libraries in lib instead of lib64
if (CCS_ARCH STREQUAL "i86")
  set(CMAKE_INSTALL_LIBDIR "lib")
endif()

file(RELATIVE_PATH relDir
    ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR}
    ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR}
)

add_library(${PROJECT_NAME} SHARED)

set_target_properties(${PROJECT_NAME}
    PROPERTIES 
        SOVERSION ${${PROJECT_NAME}_VERSION_MAJOR}
        VERSION ${${PROJECT_NAME}_VERSION}
        INSTALL_RPATH "$ORIGIN:$ORIGIN/${relDir}"
)

target_sources(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/async_util.h>
        $<INSTALL_INTERFACE:include/test/dds/async_util.h>
    PRIVATE
        async_util.cpp
)

set_target_architecture(${PROJECT_NAME})

target_include_directories(${PROJECT_NAME}
    PUBLIC
       $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> 
       $<INSTALL_INTERFACE:include/test/dds>
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE 
        test_echo
        RTIConnextDDS::cpp2_api
)


#################
#  Packaging
#################

install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}-targets
    ARCHIVE  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY  DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME  DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/test/dds
)


install(
    FILES 
        async_util.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/test/dds
)

# Use find_package on the installed library
include(CMakePackageConfigHelpers)
set(${PROJECT_NAME}_INSTALL_CMAKEDIR
    ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
    CACHE STRING "Path to ${PROJECT_NAME} cmake files"
)

install(EXPORT ${PROJECT_NAME}-targets
    DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR}
    NAMESPACE   test::
    FILE        ${PROJECT_NAME}-targets.cmake
)


configure_package_config_file (
    ${PROJECT_NAME}-config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
    INSTALL_DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR}
)
write_basic_package_version_file(
    ${PROJECT_NAME}-config-version.cmake
    VERSION ${${PROJECT_NAME}_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake
    DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKEDIR}
)


export(EXPORT ${PROJECT_NAME}-targets
    FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-targets.cmake
    NAMESPACE test::
)

export(PACKAGE ${PROJECT_NAME})


