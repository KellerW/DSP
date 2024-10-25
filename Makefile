# Variables
BUILD_DIR = build
CMAKE_FLAGS = -DARM_CROSS=ON

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
