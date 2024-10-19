cmake_minimum_required(VERSION 3.29)
project(dsp)


set(DSP_INCLUDE_DIRS
${CMAKE_SOURCE_DIR}/include
)

set(COMMON_FLAGS
    -Wall
    -Wextra
    -Werror
    -fPIC
)

set(COMMON_C_FLAGS
    ${COMMON_FLAGS}
    -std=c11
)

set(COMMON_CXX_FLAGS
    ${COMMON_FLAGS}
    -std=c++2a
)


string(REPLACE ";" " " CMAKE_COMMON_C_FLAGS "${COMMON_C_FLAGS}")
string(REPLACE ";" " " CMAKE_COMMON_CXX_FLAGS "${COMMON_CXX_FLAGS}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_COMMON_C_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  ${CMAKE_COMMON_CXX_FLAGS}" CACHE STRING "" FORCE)


#find_package(PkgConfig REQUIRED)
#pkg_check_modules(JACK REQUIRED jack)
#pkg_check_modules(SNDFILE REQUIRED sndfile)
#find_package(fmt REQUIRED)
#find_package(Curses REQUIRED)

# Find Qt libraries
#find_package(Qt5 REQUIRED COMPONENTS Core Widgets)

add_executable(${PROJECT_NAME} 
main.c
src/Strings.c)
 # src/JackClient.cpp
 # src/SimplePeakProcessor.cpp)

target_include_directories(${PROJECT_NAME} PRIVATE 
include ${DSP_INCLUDE_DIRS})

#target_link_libraries(${PROJECT_NAME} ${JACK_LIBRARIES} fmt::fmt ${CURSES_LIBRARY} Qt5::Core Qt5::Widgets ${SNDFILE_LIBRARIES})

#install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})