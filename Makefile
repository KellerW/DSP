# Variables
BUILD_DIR = build
CROSS_COMPILE ?= OFF
CMAKE_FLAGS = -DARM_CROSS=$(CROSS_COMPILE)

# Default target
all: clean_build cmake_build

# Clean the build directory if it exists
clean_build:
	@if [ -d $(BUILD_DIR) ]; then \
		echo "Removing existing build directory..."; \
		rm -rf $(BUILD_DIR); \
	fi
	@mkdir $(BUILD_DIR)
	@echo "Build directory created."

# Run CMake and build
cmake_build:
	@cd $(BUILD_DIR) && cmake $(CMAKE_FLAGS) .. && make VERBOSE=1

# Clean target to remove the build directory
clean:
	@if [ -d $(BUILD_DIR) ]; then \
		echo "Removing build directory..."; \
		rm -rf $(BUILD_DIR); \
	fi
	@echo "Clean complete."

.PHONY: all clean_build cmake_build clean

# Usage instructions
help:
	@echo "Usage: make [TARGET] [CROSS_COMPILE=ON|OFF]"
	@echo "Default CROSS_COMPILE is OFF"
	@echo "Targets:"
	@echo "  all           - Clean and build the project"
	@echo "  clean         - Remove the build directory"
	@echo "  clean_build   - Clean the build directory before building"
	@echo "  cmake_build   - Run CMake and make to build the project"
	@echo "  help          - Show this help message"
