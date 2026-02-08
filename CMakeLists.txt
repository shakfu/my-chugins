cmake_minimum_required(VERSION 3.19)
project(my-chugins LANGUAGES C CXX)

if(APPLE)
    enable_language(OBJCXX)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(cmake/fn_add_chugin.cmake)

add_subdirectory(AbletonLink)
add_subdirectory(CLAP)
add_subdirectory(PdPatch)
add_subdirectory(VST3)
