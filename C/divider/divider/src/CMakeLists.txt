set(CLOSURE_TOOLS
    divider
)

set(divider_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/Main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Visitor.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Matcher.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Topology.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Annotation.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Enclave.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/PPCallbacksClosure.cpp
)

# CONFIGURE THE TOOLS
# ===================
foreach( tool ${CLOSURE_TOOLS} )
    # Create a library corresponding to 'plugin'
    add_executable(
      ${tool}
      ${${tool}_SOURCES}
      )

    # Configure include directories for 'tool'
    target_include_directories(
      ${tool}
      PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/../include"
    )

    # Link in the required libraries 
    target_link_libraries(
      ${tool}
      "clangTooling"
    )
endforeach()
