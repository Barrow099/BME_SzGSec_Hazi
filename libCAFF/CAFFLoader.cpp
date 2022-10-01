//
// Created by Barrow099 on 2022. 10. 01..
//

#include <cstring>
#include "CAFFLoader.h"
#include "CIFFLoader.h"

#define MAX_BLOCK_SIZE (512 * 1024 * 1024)

char CAFFLoader::error_message_arr[128];
void CAFFLoader::set_error(const char *error_msg) {
    strncpy(error_message_arr, error_msg,128);
#ifdef CAFFLOADER_DEBUG
    printf("CAFFLoader: %s\n", error_msg);
#endif
}



size_t CAFFLoader::read_block(FILE *file, CAFFBlock& out_block) {
    uint8_t id;
    int64_t len;
    size_t read = fread(&id, 1,1,file);
    if(read != 1) {
        set_error("id read failed");
        return 0;
    }
    read = fread(&len, 8,1,file);
    if(read != 1) {
        set_error("len read failed");
        return 0;
    }
    if(len < 0 || len > MAX_BLOCK_SIZE) {
        set_error("uristen very big");
        return 0;
    }
    auto *bfr = new uint8_t[len];
    read = fread(bfr, 1,len,file);
    if(read != len) {
        set_error("data read failed");
        return 0;
    }
    out_block.setType(id);
    out_block.setLength(len);
    out_block.setData(bfr);
    return len;
}

CAFFAnimation *CAFFLoader::from_file(const std::string &path) {
    FILE *inf = fopen(path.c_str(), "rb");
    if(!inf) {
        set_error("error opening file");
        return nullptr;
    }
    CAFFBlock header_block;
    size_t read = read_block(inf, header_block);
    if(read == 0) {
        fclose(inf);
        return nullptr;
    }
    if(header_block.getType() != 0x1) {
        set_error("invalid CAFF file");
        fclose(inf);
        return nullptr;
    }

    if(header_block.getLength() != 20) {
        set_error("invalid CAFF header");
        fclose(inf);
        return nullptr;
    }

    if(strncmp("CAFF", reinterpret_cast<const char *>(header_block.getData()), 4) != 0) {
        set_error("invalid CAFF magic");
        fclose(inf);
        return nullptr;
    }

    int64_t header_size = *reinterpret_cast<int64_t*>(&header_block.getData()[4]);
    int64_t num_anim = *reinterpret_cast<int64_t*>(&header_block.getData()[12]);

    std::vector<CAFFAnimationFrame> frames;
    CAFFCreditsFrame creditsFrame;
    while(true) {
        CAFFBlock block;
        read = read_block(inf, block);
        if(read == 0) {
            break;
        }
        if(block.getType() == 2) {
            if(block.getLength() < 14 ) {
                set_error("skipped invalid credits block: too short");
                continue ;
            }
            int16_t YY = *reinterpret_cast<int16_t*>(block.getData());
            int8_t M = *reinterpret_cast<int8_t*>(block.getData() + 2);
            int8_t D = *reinterpret_cast<int8_t*>(block.getData() + 3);
            int8_t h = *reinterpret_cast<int8_t*>(block.getData() + 4);
            int8_t m = *reinterpret_cast<int8_t*>(block.getData() + 5);
            int64_t str_len = *reinterpret_cast<int64_t*>(block.getData() + 6);
            if(block.getLength() != 14 + str_len) {
                set_error("skipped invalid credits block: bad length");
                continue ;
            }
            std::string creator(reinterpret_cast<const char *>(block.getData() + 14), str_len);
            creditsFrame = CAFFCreditsFrame(YY,M,D,h,m,creator);
        }else if(block.getType() == 3) {
            if(block.getLength() <=8 ) {
                set_error("skipped invalid CIFF block: too short");
                continue ;
            }
            int64_t duration = *reinterpret_cast<int64_t *>(block.getData());
            CIFFImage *image = CIFFLoader::from_bytes(block.getData() + 8, block.getLength() - 8);
            frames.emplace_back(duration, image);
        }else {
            set_error("skipped invalid block: invalid type");
            continue ;
        }
    }
    if(frames.size() != num_anim) {
        set_error("frame number mismatch");
        std::for_each(frames.begin(), frames.end(), [](CAFFAnimationFrame frame) {
            delete frame.getImage();
        });
        return nullptr;
    }

    return new CAFFAnimation(creditsFrame, frames);
}
