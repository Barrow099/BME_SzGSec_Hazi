//
// Created by Barrow099 on 2022. 10. 01..
//

#ifndef LIBCAFF_CAFFLOADER_H
#define LIBCAFF_CAFFLOADER_H


#include "CAFFAnimation.h"
class CAFFLoader {
private:
    static char error_message_arr[128];
    static void set_error(const char* error_msg);
    static size_t read_block(FILE *file, CAFFBlock& block);
public:
    static CAFFAnimation* from_file(const std::string& path);
    static char *get_error_message() { return error_message_arr; }
};


#endif//LIBCAFF_CAFFLOADER_H
