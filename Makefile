# Variables
BUILD_DIR = build
CROSS_COMPILE ?= OFF
CMAKE_FLAGS = -DARM_CROSS=$(CROSS_COMPILE)
BIN_FILE = $(BUILD_DIR)/dsp.bin
FLASH_TOOL = st-flash
BINARY_FORMAT = binary

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

# Run unit tests
run_tests:
	@cd $(BUILD_DIR) && ctest --output-on-failure

# Generate coverage report (requires running unit tests first)
coverage: run_tests
	@cd $(BUILD_DIR) && lcov --capture --directory . --output-file coverage.info
	@cd $(BUILD_DIR) && genhtml coverage.info --output-directory coverage_report
	@echo "Coverage report generated in $(BUILD_DIR)/coverage_report"

# Flash target to program the microcontroller
flash:
	@echo "Flashing the microcontroller..."
	@$(FLASH_TOOL) --format $(BINARY_FORMAT) write $(BIN_FILE) 0x08000000
	@echo "Flashing complete."

# Erase the microcontroller
flash_erase:
	@echo "Erasing the microcontroller..."
	@$(FLASH_TOOL) --connect-under-reset --erase-all
	@echo "Erase complete.""

# Flash and verify the microcontroller
flash_verify:
	@echo "Flashing and verifying the microcontroller..."
	@$(FLASH_TOOL) --format $(BINARY_FORMAT) write $(BIN_FILE) 0x08000000 --verify
	@echo "Flash and verify complete.""

# Reset the microcontroller
flash_reset:
	@echo "Resetting the microcontroller..."
	@$(FLASH_TOOL) --connect-under-reset --hard-reset
	@echo "Reset complete.""

.PHONY: all clean_build cmake_build clean run_tests coverage flash flash_erase flash_verify flash_reset

# Usage instructions
help:
	@echo "Usage: make [TARGET] [CROSS_COMPILE=ON|OFF]"
	@echo "Default CROSS_COMPILE is OFF"
	@echo "Targets:"
	@echo "  all           - Clean and build the project"
	@echo "  clean         - Remove the build directory"
	@echo "  clean_build   - Clean the build directory before building"
	@echo "  cmake_build   - Run CMake and make to build the project"
	@echo "  run_tests     - Run unit tests"
	@echo "  coverage      - Generate coverage report (runs unit tests first)"
	@echo "  flash         - Flash the microcontroller with the built ELF file"
	@echo "  flash_erase   - Erase the microcontroller"
	@echo "  flash_verify  - Flash and verify the microcontroller"
	@echo "  flash_reset   - Reset the microcontroller"
	@echo "  help          - Show this help message"
