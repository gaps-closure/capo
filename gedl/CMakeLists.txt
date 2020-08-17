cmake_minimum_required(VERSION 3.13.4)
project(gedl)

find_package(LLVM REQUIRED CONFIG)

set (CMAKE_CXX_STANDARD 14)
add_compile_options("-fno-rtti")
add_compile_options("-g")

# Set your project compile flags.
# E.g. if using the C++ header files
# you will need to enable C++11 support
# for your compiler.

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

include_directories("include")
include_directories("src")



file(GLOB TPPSRC "src/*.tpp")
file(GLOB SOURCES "src/*.cpp")
file(GLOB HEADERS "include/*.hpp")

add_library(gedl MODULE
    include/tree.hh
    ${HEADERS}
    ${TPPSRC}
    ${SOURCES}
)

#
# OS X-specific configuration
#
if(APPLE)
    set_target_properties(gedl PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
endif(APPLE)