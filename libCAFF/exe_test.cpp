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
   /* FILE *f = fopen("test_ciff/1.ciff", "rb");
    if (!f) {
        printf("failed to open file\n");
        return 1;
    }
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET); *//* same as rewind(f); *//*

    char *string = new char[fsize];
    fread(string, fsize, 1, f);
    fclose(f);


    CIFFImage *image = CIFFLoader::from_bytes((uint8_t *) string, fsize);
    if (image == nullptr) {
        printf("error: %s\n", CIFFLoader::error_message());
        return 1;
    }

    FILE *out = fopen("out.rgb", "wb");
    fwrite(image->getContent(), 1, image->getContent_size(), out);
    fclose(out);
    printf("%lldx%lld\n", image->getWidth(), image->getHeight());

    CIFFWriter::write_to_file(image, "out.ciff");*/


    CAFFAnimation *anim = CAFFLoader::from_file("../test_images/crash.caff");
    if(anim == nullptr) {
        printf("CAFFLoader failed: %s\n", CAFFLoader::get_error_message());
        return 1;
    }
    printf("Loaded %lu frames by %s\n", anim->frames.size(), anim->credits.creator.c_str());
    int id = 0;
    for (const auto &item: anim->frames) {
        char filename[128];
        snprintf(filename, 127, "frame_%d.rgb", id++);
        printf("frame %d: %lldx%lld, duration: %lld\n", id-1, item.getImage()->getWidth(), item.getImage()->getHeight(), item.getDuration());
        FILE *out = fopen(filename, "wb");
        fwrite(item.getImage()->getContent(), 1, item.getImage()->getContent_size(), out);
        fclose(out);
    }
    return 0;
}