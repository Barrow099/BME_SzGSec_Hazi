//
// Created by Barrow099 on 2022. 09. 30..
//
#include "CAFFLoader.h"
#include "CIFFLoader.h"
#include "CIFFWriter.h"
#include <fstream>
#include <iostream>
#include <stdlib.h>


int main(int argc, char **argv) {
    if(argc != 3) {
        printf("Usage: %s <input file> <rgb out file>\n",argv[0]);
        return 1;
    }
    FILE *f = fopen(argv[1], "rb");
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


    CAFFAnimation *animation = CAFFLoader::from_file(argv[2]);
    FILE *out = fopen(argv[2], "wb");
    animation.
    fclose(out);
    delete animation;

    return 0;
}