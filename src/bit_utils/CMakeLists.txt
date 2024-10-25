set(LIBRARY_SOURCES "bit_utils.c")
set(LIBRARY_HEADERS "bit_utils.h")

add_library(${LIBRARY_BIT_UTILS} STATIC
    ${LIBRARY_SOURCES}
    ${LIBRARY_HEADERS})
    target_include_directories(${LIBRARY_BIT_UTILS} PUBLIC "./")