include(FetchContent)

FetchContent_Declare(
    link
    GIT_REPOSITORY https://github.com/Ableton/link.git
    GIT_TAG        Link-3.1.5
    SOURCE_SUBDIR  include
    EXCLUDE_FROM_ALL
)

FetchContent_MakeAvailable(link)

# Link creates Ableton::Link as a non-GLOBAL IMPORTED target, so it's
# invisible outside the subdirectory scope that FetchContent runs it in.
# SOURCE_SUBDIR=include skips Link's root CMakeLists.txt (which would also
# build examples/tests), and we include the config here so the target is
# created in our scope and visible to add_chugin.
include(${link_SOURCE_DIR}/AbletonLinkConfig.cmake)

add_chugin(
    SOURCES
        abl_link_instance.cpp
        AbletonLink.cpp
    LINK_LIBS
        Ableton::Link
)
