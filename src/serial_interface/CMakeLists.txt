set(LIBRARY_SOURCES "serial_interface.c")
set(LIBRARY_HEADERS "serial_interface.h")

add_library(${LIBRARY_SERIAL_INTERFACE} STATIC
    ${LIBRARY_SOURCES}
    ${LIBRARY_HEADERS})
    target_include_directories(${LIBRARY_SERIAL_INTERFACE} PUBLIC "./")