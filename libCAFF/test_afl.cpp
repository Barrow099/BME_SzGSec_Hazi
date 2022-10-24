//
// Created by Barrow099 on 2022. 10. 01..
//

#include "CAFFLoader.h"
#include "CIFFLoader.h"
#include <cstdio>
#include <cstring>
typedef enum mode {
    INVALID,
    CAFF,
    CIFF
} mode;

int main(int argc, char **argv) {
    if(argc != 3) {
        printf("Usage: %s [-caff|--ciff] <input_file>\n",argv[0]);
        return 1;
    }
    int mode = INVALID;

    if (strcmp(argv[1], "--caff") == 0) {
        mode = CAFF;
    } else if (strcmp(argv[1], "--ciff") == 0) {
        mode = CIFF;
    }

    if (mode == INVALID) {
        printf("Invalid mode");
        return 1;
    }
    printf("Mode: %s\n", mode == CAFF ? "CAFF" : "CIFF");

    FILE *f = fopen(argv[2], "rb");
    if (!f) {
        perror("failed to open file\n");
        return 1;
    }
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET); /* same as rewind(f); */

    char *string = new char[fsize];
    fread(string, fsize, 1, f);
    fclose(f);

    if(mode == CAFF) {
        CAFFAnimation *animation = CAFFLoader::from_file(argv[2]);
        delete animation;
    }else {
        CIFFImage *image = CIFFLoader::from_bytes(reinterpret_cast<uint8_t *>(string), fsize);
        delete image;
    }

    delete[] string;

    return 0;
}