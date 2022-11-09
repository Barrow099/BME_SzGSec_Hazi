//
// Created by Barrow099 on 2022. 09. 30..
//

#include "capi.h"
#include "CIFFLoader.h"
#include "CIFFWriter.h"
#include "CAFFLoader.h"

CIFFImage_h *CIFFLoader_from_bytes(uint8_t *bytes, size_t len) {
    return reinterpret_cast<CIFFImage_h *>(CIFFLoader::from_bytes(bytes, len));
}
CIFFImage_h *CIFFLoader_from_file(const char *path) {
    return reinterpret_cast<CIFFImage_h *>(CIFFLoader::from_file(std::string(path)));
}
char *CIFFLoader_error_message() {
    return CIFFLoader::error_message();
}
void CIFFWriter_to_file(CIFFImage_h *image, const char *path) {
    CIFFWriter::write_to_file(reinterpret_cast<CIFFImage *>(image), std::string(path));
}
bool CIFFWriter_to_bytes(CIFFImage_h *image, uint8_t *out_data, size_t buffer_size, size_t *written_size) {
    auto bytes = CIFFWriter::to_bytes(reinterpret_cast<CIFFImage *>(image));
    if(bytes.size() > buffer_size) {
        *out_data = 0;
        return false;
    }else {
        memcpy(out_data, bytes.data(), bytes.size());
        *written_size = bytes.size();
        return true;
    }
}
CIFFImage_h *CIFFImage_new(int64_t width, int64_t height, char *caption, char **tags, size_t numOfTags, uint8_t *content, uint64_t content_size) {
    std::vector<std::string> tag_vec;
    for (int i = 0; i < numOfTags; i++) {
        tag_vec.emplace_back(tags[i]);
    }
    return (CIFFImage_h *) new CIFFImage(width, height,caption, tag_vec, content, content_size);
}
void CIFFImage_delete(CIFFImage_h *image) {
    delete ((CIFFImage*) image);
}
int64_t CIFFImage_getWidth(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getWidth();
}
int64_t CIFFImage_getHeight(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getHeight();
}
int64_t CIFFImage_getContentSize(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getContent_size();
}
uint8_t *CIFFImage_getContent(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getContent();
}
char *CIFFImage_getCaption(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getCaption();
}
size_t CIFFImage_getTagCount(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getTag_count();
}
char **CIFFImage_getTags(CIFFImage_h *image) {
    return ((CIFFImage*)image)->getTags();
}
CAFFAnimation_h *CAFFLoader_from_file(const char *path) {
    return reinterpret_cast<CAFFAnimation_h *>(CAFFLoader::from_file(path));
}
char *CAFFLoader_error_message() {
    return CAFFLoader::get_error_message();
}
const char *CAFFAnimation_getCreator(CAFFAnimation_h *anim) {
    return ((CAFFAnimation*)anim)->credits.creator.c_str();
}
void CAFFAnimation_delete(CAFFAnimation_h *anim) {
    delete anim;
}
CAFFAnimationFrame_h *CAFFAnimation_getFrames(CAFFAnimation_h *anim) {
    return reinterpret_cast<CAFFAnimationFrame_h *>(((CAFFAnimation *) anim)->frames.data());
}
int64_t CAFFAnimation_getFrameCount(CAFFAnimation_h *anim) {
    return ((CAFFAnimation *) anim)->frames.size();
}

uint8_t *CAFFAnimation_getPreview(CAFFAnimation_h *anim) {
    return ((CAFFAnimation *) anim)->preview()->getContent();
}

int64_t CAFFAnimation_getPreviewSize(CAFFAnimation_h *frame) {
    return ((CAFFAnimation *) frame)->preview()->getContent_size();
}

int64_t CAFFAnimation_getPreviewWidth(CAFFAnimation_h *frame) {
    return ((CAFFAnimation *) frame)->preview()->getWidth();
}

int64_t CAFFAnimation_getPreviewHeight(CAFFAnimation_h *frame) {
    return ((CAFFAnimation *) frame)->preview()->getHeight();
}

int64_t CAFFAnimationFrame_getDuration(CAFFAnimationFrame_h *frame) {
    return ((CAFFAnimationFrame *) frame)->getDuration();
}


CIFFImage_h *CAFFAnimationFrame_getImage(CAFFAnimationFrame_h *frame) {
    return reinterpret_cast<CIFFImage_h *>(((CAFFAnimationFrame *) frame)->getImage());
}
