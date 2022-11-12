BUILD_DIR = build
OBJ = $(addprefix $(BUILD_DIR)/, CAFFAnimation.o CAFFLoader.o capi.o CIFFImage.o CIFFLoader.o CIFFWriter.o)
SHARED_LIB_NAME = libCAFF.so
EXE_NAME = caff_preview

.PHONY: all clean shared
all: $(BUILD_DIR)/$(EXE_NAME)
shared: $(BUILD_DIR)/$(SHARED_LIB_NAME)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
$(BUILD_DIR)/%.o: %.cpp $(BUILD_DIR)
	$(CXX) -c $(CFLAGS) -fPIC -std=c++14 $(CPPFLAGS) $< -o $@

$(BUILD_DIR)/$(SHARED_LIB_NAME): $(OBJ)
	$(CXX) $(LDFLAGS) -shared $(OBJ) -o $@

$(BUILD_DIR)/libCAFF.a: $(OBJ)
	ar rcs $@ $(OBJ)

$(BUILD_DIR)/$(EXE_NAME): $(BUILD_DIR)/preview.o $(BUILD_DIR)/libCAFF.a
	$(CXX) $(LDFLAGS) -L $(BUILD_DIR) $(BUILD_DIR)/preview.o -lCAFF -o $@

clean:
	@rm -rf $(BUILD_DIR)