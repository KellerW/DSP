cmake_minimum_required(VERSION 3.29)

project(dsp)

set(TEST_EXECUTABLE
    dsp_test
)

set(ELF ${PROJECT_NAME}.elf)

enable_language(ASM)

set(STARTUP_FILE "src/startup_stm32f103xb.c")

if(ARM_CROSS)
    set(CMAKE_FIND_ROOT_PATH /usr/lib/arm-none-eabi)
    set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/linker/stm32f103.ld)
    set(CMAKE_SYSTEM_NAME Generic)
    set(CMAKE_SYSTEM_PROCESSOR arm)
    set(CMAKE_OBJCOPY arm-none-eabi-objcopy)

    # Specify the cross compiler executables
    set(CMAKE_C_COMPILER arm-none-eabi-gcc)
    set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
    set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
    # Don't look for standard system libraries or programs
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
endif()

set(DSP_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/include
)
set(LIBRARY_STRINGS
    strings)

set(LIBRARY_BIT_UTILS
    bit_utils)
    
set(LIBRARY_SERIAL_INTERFACE
serial_interface) 

set(COMMON_FLAGS
    -Wall
    -Wextra
    -Werror
    -fPIC
)
if(NOT ARM_CROSS)
    list(APPEND COMMON_FLAGS -fprofile-arcs -ftest-coverage)
endif()

set(COMMON_C_FLAGS
     ${COMMON_FLAGS}
     -std=c11
)

string(REPLACE ";" " " CMAKE_COMMON_C_FLAGS "${COMMON_C_FLAGS}")

# Append the common flags to CMAKE_C_FLAGS
if(NOT ARM_CROSS)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_COMMON_C_FLAGS}")
    #set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_COMMON_C_FLAGS}" CACHE STRING "" FORCE)
else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mcpu=cortex-m3 -mthumb -O2 -ffreestanding -Wall")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LINKER_SCRIPT} -nostartfiles -Wl,--gc-sections")
endif()

if(NOT ARM_CROSS)
add_executable(${PROJECT_NAME} 
    src/main.c
)
target_link_libraries(${PROJECT_NAME} ${LIBRARY_STRINGS} ${LIBRARY_BIT_UTILS} ${LIBRARY_SERIAL_INTERFACE})
else()
add_executable(${ELF} ${STARTUP_FILE}
  src/main.c
)
target_link_libraries(${ELF} ${LIBRARY_STRINGS} ${LIBRARY_BIT_UTILS} ${LIBRARY_SERIAL_INTERFACE})
endif()

target_compile_options(${ELF} PUBLIC
  -Wall 
  -g 
  -std=gnu99 
  -Os
  -mthumb
  -mcpu=cortex-m3
  -mfloat-abi=soft
  -mlittle-endian
  -ffunction-sections 
  -fdata-sections
  -Werror 
  -Wstrict-prototypes 
  -Warray-bounds 
  -fno-strict-aliasing 
  -Wno-unused-const-variable 
  -specs=nano.specs 
  -specs=nosys.specs
  )

# Add a custom target for Frama-C analysis
add_custom_target(
    frama_c_analysis
    COMMAND frama-c -eva ${CMAKE_SOURCE_DIR}/src/main.c -cpp-extra-args="-I${CMAKE_SOURCE_DIR}/include" > ${CMAKE_SOURCE_DIR}/Coverity/frama_c_report.txt
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src
    COMMENT "Running Frama-C extended value analysis on main.c and saving report"
    VERBATIM
)

add_custom_target(coverage
    COMMAND ${CMAKE_COMMAND} -E env GCOV_PREFIX=${CMAKE_BINARY_DIR} GCOV_PREFIX_STRIP=${CMAKE_BINARY_DIR} lcov --capture --directory ${CMAKE_BINARY_DIR} --output-file ${CMAKE_BINARY_DIR}/coverage.info
    COMMAND genhtml ${CMAKE_BINARY_DIR}/coverage.info --output-directory ${CMAKE_BINARY_DIR}/coverage_report
    DEPENDS UnitTests # Make sure tests are run before generating the report
)

add_custom_command(TARGET ${ELF} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary ${ELF} ${PROJECT_NAME}.bin
    COMMENT "Converting ${PROJECT_NAME} to binary format"
)

add_subdirectory(src)
#target_include_directories(${PROJECT_NAME} PRIVATE 
#include ${DSP_INCLUDE_DIRS})
message(STATUS "Linker flags: ${CMAKE_EXE_LINKER_FLAGS}")
message(STATUS "Compiler flags: ${CMAKE_C_FLAGS}")

if(NOT ARM_CROSS)
    # Set Unit Test
    # -----------------------------------------------------
    include(CTest)
    # Add the source files and headers
    add_subdirectory(Unity)
    #add_library(unity STATIC IMPORTED)
    set_target_properties(unity PROPERTIES IMPORTED_LOCATION /home/wagner/work/dsp/Unity/build/libunity.a)
    # Enable testing
    enable_testing()
    add_test(NAME UnitTests COMMAND UnitTests)
    #Add unit test target
    add_executable(
        UnitTests
        tests/test_main.c
    )
    target_link_libraries(UnitTests PRIVATE unity ${LIBRARY_BIT_UTILS})
endif()

#install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})