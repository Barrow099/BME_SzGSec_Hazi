BUILD_DIR = build
OBJ = $(addprefix $(BUILD_DIR)/, CAFFAnimation.o CAFFLoader.o capi.o CIFFImage.o CIFFLoader.o CIFFWriter.o)
SHARED_LIB_NAME = libCAFF.so

.PHONY: all clean
all: $(BUILD_DIR)/$(SHARED_LIB_NAME)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
$(BUILD_DIR)/%.o: %.cpp $(BUILD_DIR)
	$(CXX) -c $(CFLAGS) -fPIC -std=c++14 $(CPPFLAGS) $< -o $@

$(BUILD_DIR)/$(SHARED_LIB_NAME): $(OBJ)
	$(CXX) $(LDFLAGS) -shared $(OBJ) -o $@

clean:
	@rm -rf $(BUILD_DIR)