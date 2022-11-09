//
// Created by Barrow099 on 2022. 09. 30..
//

#ifndef LIBCAFF_CAPI_H
#define LIBCAFF_CAPI_H

#include <cstddef>
#include <cstdint>
#define WIN_EXPORT 1
#if defined _WIN32 || defined __CYGWIN__
#ifdef WIN_EXPORT
// Exporting...
#ifdef __GNUC__
#define EXPORTED __attribute__ ((dllexport))
#else
#define EXPORTED __declspec(dllexport) // Note: actually gcc seems to also supports this syntax.
#endif
#else
#ifdef __GNUC__
#define EXPORTED __attribute__ ((dllimport))
#else
#define EXPORTED __declspec(dllimport) // Note: actually gcc seems to also supports this syntax.
#endif
#endif
#define NOT_EXPORTED
#else
#if __GNUC__ >= 4
#define EXPORTED __attribute__ ((visibility ("default")))
#define NOT_EXPORTED  __attribute__ ((visibility ("hidden")))
#else
#define EXPORTED
#define NOT_EXPORTED
#endif
#endif



#ifdef __cplusplus
extern "C" {
#endif

typedef struct CIFFImage_h {
    char placeholder;
} CIFFImage_h;
typedef struct CAFFAnimation_h {
    char placeholder;
} CAFFAnimation_h;
typedef struct CAFFAnimationFrame_h {
    char placeholder;
} CAFFAnimationFrame_h;
// CIFFLoader
EXPORTED CIFFImage_h* CIFFLoader_from_bytes(uint8_t *bytes, size_t len);
EXPORTED CIFFImage_h* CIFFLoader_from_file(const char* path);
EXPORTED char* CIFFLoader_error_message();

//CIFFWriter
EXPORTED void CIFFWriter_to_file(CIFFImage_h *image, const char* path);
EXPORTED bool CIFFWriter_to_bytes(CIFFImage_h *image, uint8_t *out_data, size_t buffer_size, size_t *written_size);

//CIFFImage
EXPORTED CIFFImage_h* CIFFImage_new(int64_t width, int64_t height, char *caption, char **tags, size_t numOfTags, uint8_t *content, uint64_t content_size);
EXPORTED void CIFFImage_delete(CIFFImage_h* image);
EXPORTED int64_t CIFFImage_getWidth(CIFFImage_h* image);
EXPORTED int64_t CIFFImage_getHeight(CIFFImage_h* image);
EXPORTED int64_t CIFFImage_getContentSize(CIFFImage_h* image);
EXPORTED uint8_t* CIFFImage_getContent(CIFFImage_h* image);
EXPORTED char* CIFFImage_getCaption(CIFFImage_h *image);
EXPORTED size_t CIFFImage_getTagCount(CIFFImage_h* image);
EXPORTED char** CIFFImage_getTags(CIFFImage_h* image);

//CAFFLoader
EXPORTED CAFFAnimation_h *CAFFLoader_from_file(const char* path);
EXPORTED char *CAFFLoader_error_message();

//CAFFAnimation
EXPORTED const char *CAFFAnimation_getCreator(CAFFAnimation_h *);
EXPORTED void CAFFAnimation_delete(CAFFAnimation_h *);
EXPORTED CAFFAnimationFrame_h *CAFFAnimation_getFrames(CAFFAnimation_h *);
EXPORTED int64_t CAFFAnimation_getFrameCount(CAFFAnimation_h *);
EXPORTED uint8_t* CAFFAnimation_getPreview(CAFFAnimation_h *);
EXPORTED int64_t CAFFAnimation_getPreviewSize(CAFFAnimation_h *);
EXPORTED int64_t CAFFAnimation_getPreviewWidth(CAFFAnimation_h *);
EXPORTED int64_t CAFFAnimation_getPreviewHeight(CAFFAnimation_h *);

//CAFFAnimationFrame
EXPORTED int64_t CAFFAnimationFrame_getDuration(CAFFAnimationFrame_h* frame);
EXPORTED CIFFImage_h *CAFFAnimationFrame_getImage(CAFFAnimationFrame_h* frame);

#ifdef __cplusplus
}
#endif
#endif//LIBCAFF_CAPI_H
