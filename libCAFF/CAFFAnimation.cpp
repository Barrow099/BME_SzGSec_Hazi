//
// Created by Barrow099 on 2022. 10. 01..
//

#include "CAFFAnimation.h"
#include <cstring>
CAFFCreditsFrame::CAFFCreditsFrame(uint16_t yy, uint8_t m, uint8_t d, uint8_t h, uint8_t m1, const std::string &creator) : YY(yy), M(m), D(d), h(h), m(m1), creator(creator) {}
CAFFCreditsFrame::CAFFCreditsFrame() {}
uint8_t CAFFBlock::getType() const {
    return type;
}
void CAFFBlock::setType(uint8_t type) {
    CAFFBlock::type = type;
}
uint64_t CAFFBlock::getLength() const {
    return length;
}
void CAFFBlock::setLength(uint64_t length) {
    CAFFBlock::length = length;
}
uint8_t *CAFFBlock::getData() const {
    return data;
}
void CAFFBlock::setData(uint8_t *data) {
    CAFFBlock::data = data;
}
CAFFBlock::CAFFBlock(uint8_t type, uint64_t length, uint8_t *data) : type(type), length(length), data(data) {}
CAFFBlock::CAFFBlock() : type(0), length(0), data(nullptr) {}
CAFFBlock::~CAFFBlock() {
    delete[] this->data;
    this->data = nullptr;
}

CAFFAnimationFrame::CAFFAnimationFrame(uint64_t duration, CIFFImage *image) : duration(duration), image(image) {}
CIFFImage *CAFFAnimationFrame::getImage() const {
    return this->image;
}
int64_t CAFFAnimationFrame::getDuration() const {
    return this->duration;
}
CAFFAnimation::CAFFAnimation(CAFFCreditsFrame credits, std::vector<CAFFAnimationFrame> frames) {
    this->credits = credits;
    this->frames = frames;
}
