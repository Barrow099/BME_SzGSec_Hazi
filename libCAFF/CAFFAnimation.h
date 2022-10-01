//
// Created by Barrow099 on 2022. 10. 01..
//

#ifndef LIBCAFF_CAFFANIMATION_H
#define LIBCAFF_CAFFANIMATION_H

#include "CIFFImage.h"
#include <cstdint>
#include <string>
struct CAFFCreditsFrame {
    uint16_t YY;
    uint8_t M;
    uint8_t D;
    uint8_t h;
    uint8_t m;
    std::string creator;

public:
    CAFFCreditsFrame(uint16_t yy, uint8_t m, uint8_t d, uint8_t h, uint8_t m1, const std::string &creator);
    CAFFCreditsFrame();
};


class __attribute__ ((packed)) CAFFAnimationFrame {
    uint64_t duration;
    CIFFImage *image;

public:
    CAFFAnimationFrame(uint64_t duration, CIFFImage *image);
    CIFFImage *getImage() const;
    int64_t getDuration() const;
};

struct CAFFHeaderBlock {
    char magic[4];
    int64_t header_size;
    int64_t num_anim;
    CAFFHeaderBlock(uint8_t* buff, size_t len);
};

class CAFFBlock {
    uint8_t type;
    uint64_t length;
    uint8_t *data;


public:
    CAFFBlock(uint8_t type, uint64_t length, uint8_t *data);
    explicit CAFFBlock();
    uint8_t getType() const;
    void setType(uint8_t type);
    uint64_t getLength() const;
    void setLength(uint64_t length);
    uint8_t *getData() const;
    void setData(uint8_t *data);
};

struct CAFFAnimation {
    CAFFCreditsFrame credits;
    std::vector<CAFFAnimationFrame> frames;
public:
    CAFFAnimation(CAFFCreditsFrame credits, std::vector<CAFFAnimationFrame> frames);
    virtual ~CAFFAnimation() {
        std::for_each(frames.begin(), frames.end(), [](CAFFAnimationFrame frame) {
            delete frame.getImage();
        });
    }
};


#endif//LIBCAFF_CAFFANIMATION_H
