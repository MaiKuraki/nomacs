add_definitions(-DWITH_PLUGINS)

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
  message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas")

# create the targets
set(BINARY_NAME ${CMAKE_PROJECT_NAME})
set(DLL_CORE_NAME ${CMAKE_PROJECT_NAME}Core)
set(DLL_LOADER_NAME ${CMAKE_PROJECT_NAME}Loader)
set(DLL_NAME ${CMAKE_PROJECT

#binary
link_directories(${LIBRAW_LIBRARY_DIRS} ${OpenCV_LIBRARY_DIRS} ${EXIV2_LIBRARY_DIRS} ${CMAKE_BINARY_DIR})
add_executable(${BINARY_NAME} WIN32  MACOSX_BUNDLE ${NOMACS_EXE_SOURCES} ${NOMACS_EXE_HEADERS} ${NOMACS_QM} ${NOMACS_TRANSLATIONS} ${NOMACS_RC} ${QUAZIP_SOURCES} ${WEBP_SOURCE})  
target_link_libraries(${BINARY_NAME} ${DLL_NAME} ${DLL_CORE_NAME} ${DLL_LOADER_NAME} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARIES} ${WEBP_STATIC_LIBRARIES} ${ZLIB_LIBRARY} ${LIBQPSD_LIBRARY})


set_target_properties(${BINARY_NAME} PROPERTIES COMPILE_FLAGS "-DDK_DLL_IMPORT -DNOMINMAX")
set_target_properties(${BINARY_NAME} PROPERTIES IMPORTED_IMPLIB "")

# add core
add_library(${DLL_CORE_NAME} SHARED ${CORE_SOURCES} ${NOMACS_UI} ${CORE_HEADERS} ${NOMACS_RCC} ${NOMACS_RC})
target_link_libraries(${DLL_CORE_NAME} ${VERSION_LIB} ${OpenCV_LIBS}) 

# add loader
add_library(${DLL_LOADER_NAME} SHARED ${LOADER_SOURCES} ${NOMACS_UI} ${NOMACS_RCC} ${LOADER_HEADERS} ${AUTOFLOW_RC} ${QUAZIP_SOURCES} ${WEBP_SOURCE} ${LIBQPSD_SOURCES} ${LIBQPSD_HEADERS})
target_link_libraries(${DLL_LOADER_NAME} ${DLL_CORE_NAME} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARY}) 

# add GUI
add_library(${DLL_NAME} SHARED ${GUI_SOURCES} ${NOMACS_UI} ${NOMACS_RCC} ${GUI_HEADERS} ${NOMACS_RC})
target_link_libraries(${DLL_NAME} ${DLL_CORE_NAME} ${DLL_LOADER_NAME} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARIES} ${WEBP_STATIC_LIBRARIES}) 


add_dependencies(${DLL_LOADER_NAME} ${DLL_CORE_NAME})
add_dependencies(${DLL_NAME} ${DLL_LOADER_NAME} ${DLL_CORE_NAME})
add_dependencies(${BINARY_NAME} ${DLL_NAME} ${DLL_LOADER_NAME} ${DLL_CORE_NAME} ${QUAZIP_DEPENDENCY} ${LIBQPSD_LIBRARY} ${WEBP_LIBRARY} ${WEBP_STATIC_LIBRARIES}) 

qt5_use_modules(${BINARY_NAME} 		Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)
qt5_use_modules(${DLL_NAME} 		Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)
qt5_use_modules(${DLL_LOADER_NAME} 	Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)
qt5_use_modules(${DLL_CORE_NAME} 	Widgets Gui Network LinguistTools PrintSupport Concurrent Svg)

# core flags
set_target_properties(${DLL_CORE_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_CORE_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_CORE_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_REALLYRELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)

set_target_properties(${DLL_CORE_NAME} PROPERTIES COMPILE_FLAGS "-DDK_CORE_DLL_EXPORT -DNOMINMAX")
set_target_properties(${DLL_CORE_NAME} PROPERTIES DEBUG_OUTPUT_NAME ${DLL_CORE_NAME}d)
set_target_properties(${DLL_CORE_NAME} PROPERTIES RELEASE_OUTPUT_NAME ${DLL_CORE_NAME})

# loader flags
set_target_properties(${DLL_LOADER_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_LOADER_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_LOADER_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_REALLYRELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)

set_target_properties(${DLL_LOADER_NAME} PROPERTIES COMPILE_FLAGS "-DDK_LOADER_DLL_EXPORT -DNOMINMAX")
set_target_properties(${DLL_LOADER_NAME} PROPERTIES DEBUG_OUTPUT_NAME ${DLL_LOADER_NAME}d)
set_target_properties(${DLL_LOADER_NAME} PROPERTIES RELEASE_OUTPUT_NAME ${DLL_LOADER_NAME})

# gui flags
set_target_properties(${DLL_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)
set_target_properties(${DLL_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_REALLYRELEASE ${CMAKE_CURRENT_BINARY_DIR}/libs)

set_target_properties(${DLL_NAME} PROPERTIES COMPILE_FLAGS "-DDK_GUI_DLL_EXPORT -DNOMINMAX")
set_target_properties(${DLL_NAME} PROPERTIES DEBUG_OUTPUT_NAME ${DLL_NAME}d)
set_target_properties(${DLL_NAME} PROPERTIES RELEASE_OUTPUT_NAME ${DLL_NAME})

target_link_libraries(${DLL_NAME} ${QT_QTCORE_LIBRARY} ${QT_QTGUI_LIBRARY} ${QT_QTSVG_LIBRARY} ${QT_QTNETWORK_LIBRARY} ${QT_QTMAIN_LIBRARY} ${EXIV2_LIBRARIES} ${LIBRAW_LIBRARIES} ${OpenCV_LIBS} ${VERSION_LIB} ${TIFF_LIBRARIES} ${HUPNP_LIBS} ${HUPNPAV_LIBS} ${QUAZIP_LIBRARIES} ${WEBP_LIBRARY}) 


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas")

# mac's bundle install
set_target_properties(${BINARY_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST "${CMAKE_SOURCE_DIR}/macosx/Info.plist.in")
set(MACOSX_BUNDLE_ICON_FILE nomacs.icns)
set(MACOSX_BUNDLE_INFO_STRING "${BINARY_NAME} ${NOMACS_VERSION}")
set(MACOSX_BUNDLE_GUI_IDENTIFIER "org.nomacs")
set(MACOSX_BUNDLE_LONG_VERSION_STRING "${NOMACS_VERSION}")
set(MACOSX_BUNDLE_BUNDLE_NAME "${BINARY_NAME}")
set(MACOSX_BUNDLE_SHORT_VERSION_STRING "${NOMACS_VERSION}")
set(MACOSX_BUNDLE_BUNDLE_VERSION "${NOMACS_VERSION}")
set(MACOSX_BUNDLE_COPYRIGHT "(c) Nomacs team")
set_source_files_properties(${CMAKE_SOURCE_DIR}/macosx/nomacs.icns PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

install(TARGETS ${BINARY_NAME} BUNDLE DESTINATION ${CMAKE_INSTALL_PREFIX})

# create a "transportable" bundle - all libs into the bundle: "make bundle" after make install
configure_file(${CMAKE_SOURCE_DIR}/macosx/bundle.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/bundle.cmake @ONLY)
add_custom_target(bundle ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/bundle.cmake)

# generate configuration file
set(NOMACS_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(NOMACS_BUILD_DIRECTORY ${CMAKE_BINARY_DIR})
configure_file(${NOMACS_SOURCE_DIR}/nomacs.cmake.in ${CMAKE_BINARY_DIR}/nomacsConfig.cmake)
