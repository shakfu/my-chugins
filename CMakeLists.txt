cmake_minimum_required(VERSION 3.19)
project(my-chugins LANGUAGES C CXX)

if(APPLE)
    enable_language(OBJCXX)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Chugins are MODULE libraries (dynamically loaded .chug files).
# This prevents fn_add_chugin.cmake from defining __CK_DLL_STATIC__,
# which would suppress the ck_version export that chuck needs to load them.
set(BUILD_SHARED_LIBS ON)

include(cmake/fn_add_chugin.cmake)

add_subdirectory(AbletonLink)
add_subdirectory(CLAP)
add_subdirectory(PdPatch)
add_subdirectory(VST3)
