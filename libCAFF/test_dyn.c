#include <dlfcn.h>
#include <stdio.h>

typedef struct CIFFImage_h {} CIFFImage_h;

int main(int argc, char **argv) {
    void *handle = dlopen("cmake-build-debug/libCAFF.dylib",RTLD_LAZY);
    if(!handle) {
        perror("dlopen");
        return 1;
    }

    CIFFImage_h *(*CIFFLoader_from_file)(const char* path) = dlsym(handle, "CIFFLoader_from_file");
    char*(*CIFFLoader_error_message)(void) = dlsym(handle, "CIFFLoader_error_message");
    if(!CIFFLoader_from_file || !CIFFLoader_error_message) {
        perror("dlsym");
        return 1;
    }

    CIFFImage_h *image = CIFFLoader_from_file("test_images/1.ciff");
    if(!image) {
        printf("CAFF loading failed: %s\n", CIFFLoader_error_message());
        return 1;
    }


    dlclose(handle);
    return 0;
}