//
// Created by Barrow099 on 2022. 09. 30..
//

#ifndef LIBCAFF_CIFFWRITER_H
#define LIBCAFF_CIFFWRITER_H


#include "CIFFImage.h"
class CIFFWriter {
public:
    static std::vector<uint8_t> to_bytes(CIFFImage* image);
    static void write_to_file(CIFFImage *image, const std::string& file_name);

};


#endif//LIBCAFF_CIFFWRITER_H
