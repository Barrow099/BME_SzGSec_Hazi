//
// Created by Barrow099 on 2022. 09. 30..
//

#ifndef LIBCAFF_CIFFLOADER_H
#define LIBCAFF_CIFFLOADER_H

#include "CIFFImage.h"
#include <string_view>

class CIFFLoader {
private:
    static char error_message_arr[128];
    static void set_error(const char* error_msg);
public:
    static CIFFImage *from_file(const std::string& path);
    static CIFFImage *from_bytes(uint8_t *bytes, size_t len);
    static char* error_message();
};


#endif//LIBCAFF_CIFFLOADER_H
