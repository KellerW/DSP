set(LIBRARY_SOURCES "strings.c")
set(LIBRARY_HEADERS "strings.h")

add_library(${LIBRARY_STRINGS} STATIC
    ${LIBRARY_SOURCES}
    ${LIBRARY_HEADERS})
    target_include_directories(${LIBRARY_STRINGS} PUBLIC "./")