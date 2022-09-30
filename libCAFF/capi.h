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

typedef struct CIFFImage_h {} CIFFImage_h;
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
EXPORTED int64_t getWidth(CIFFImage_h* image);
EXPORTED int64_t getHeight(CIFFImage_h* image);
EXPORTED int64_t getContentSize(CIFFImage_h* image);
EXPORTED uint8_t* getContent(CIFFImage_h* image);
EXPORTED char* getCaption(CIFFImage_h *image);
EXPORTED size_t getTagCount(CIFFImage_h* image);
EXPORTED char** getTags(CIFFImage_h* image);

#ifdef __cplusplus
}
#endif
#endif//LIBCAFF_CAPI_H
