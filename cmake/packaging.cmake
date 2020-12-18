# Package version info
# Bump this number in your CMakeLists.txt IF the RPM is updated
# using the function update_package_release
# If a new software version is released, reset to 1
# RPM packaging rules require this number match the
# most recent version and release number in the change log.
set(CPACK_RPM_PACKAGE_RELEASE 1)

# General metadata
set(CPACK_PACKAGE_NAME "test_${PROJECT_NAME}")
set(CPACK_SYSTEM_NAME "el7")
set(CPACK_PACKAGE_VENDOR "Test")

# General packaging rules
set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")

set(CPACK_GENERATOR "RPM;${CPACK_GENERATOR}")
set(CPACK_SOURCE_GENERATOR "RPM;${CPACK_GENERATOR}")
set(CPACK_PACKAGE_RELOCATABLE TRUE)
set(CPACK_SOURCE_PACKAGE_RELOCATABLE TRUE)
set(CPACK_SOURCE_IGNORE_FILES 
  "${CMAKE_SOURCE_DIR}/.git/" 
  "${CMAKE_SOURCE_DIR}/.gitignore" 
  "${CMAKE_SOURCE_DIR}/build/"
  "${CMAKE_SOURCE_DIR}/tags"
)

# RPM specific metadata
set(CPACK_RPM_PACKAGE_GROUP "Test")
set(CPACK_RPM_COMPONENT_INSTALL OFF)

if (CCS_ARCH STREQUAL "i86")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "i686")
elseif (CCS_ARCH STREQUAL "x64")
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
else ()
  set(CPACK_RPM_PACKAGE_ARCHITECTURE "${CCS_ARCH}")
endif()
set(CPACK_RPM_PACKAGE_RELEASE_DIST ${CPACK_SYSTEM_NAME})

set(CPACK_RPM_CHANGELOG_FILE "${CMAKE_SOURCE_DIR}/rpm-changelog.txt")

function(update_package_release release_number)
    set(CPACK_RPM_PACKAGE_RELEASE ${release_number} PARENT_SCOPE)
    set(CPACK_RPM_FILE_NAME RPM-DEFAULT PARENT_SCOPE)
endfunction()

update_package_release(${CPACK_RPM_PACKAGE_RELEASE})

