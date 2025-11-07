
add_subdirectory(vst3sdk)

# VST3 Chugin CMakeLists.txt

set(VST3_SDK_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/vst3sdk")

# Platform-specific VST3 hosting module sources
if(CMAKE_HOST_APPLE)
    set(VST3_MODULE_SOURCE "${VST3_SDK_ROOT}/public.sdk/source/vst/hosting/module_mac.mm")
    set_source_files_properties(
        "${VST3_MODULE_SOURCE}" PROPERTIES
        COMPILE_FLAGS "-fobjc-arc"
    )
elseif(CMAKE_HOST_LINUX)
    set(VST3_MODULE_SOURCE "${VST3_SDK_ROOT}/public.sdk/source/vst/hosting/module_linux.cpp")
elseif(CMAKE_HOST_WIN32)
    set(VST3_MODULE_SOURCE "${VST3_SDK_ROOT}/public.sdk/source/vst/hosting/module_win32.cpp")
endif()

add_chugin(
	OTHER_SOURCES
		${VST3_MODULE_SOURCE}
	COMPILE_DEFINITIONS
		HAVE_VST3_SDK
	LINK_LIBS
		base
		sdk
		sdk_common
		pluginterfaces
		sdk_hosting
        "$<$<PLATFORM_ID:Darwin>:-framework CoreFoundation>"
        "$<$<PLATFORM_ID:Darwin>:-framework CoreServices>"
)
