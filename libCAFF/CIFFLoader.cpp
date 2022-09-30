//

#include "CIFFLoader.h"
#include <vector>
#include <string>

//
// Created by Barrow099 on 2022. 09. 30..


/**
 * Helper class for reading binary stream
 *
 * All multibyte read operations assume platform endianness
 */
class ReaderIterator {
private:
    size_t pos;
    size_t len;
    uint8_t* bytes;

private:
    bool checkPos(size_t required) const {
        return pos + required <= len;
    }

public:
    ReaderIterator(uint8_t* bytes, size_t len) : len(len), bytes(bytes) {
        pos = 0;
    }

    int8_t readByte() {
        if(checkPos(sizeof(int8_t))) {
            int8_t retval = *reinterpret_cast<int8_t*>(&bytes[pos]);
            pos += sizeof(int8_t);
            return retval;
        }
        return -1;
    }

    int64_t readLong() {
        if(checkPos(sizeof(int64_t))) {
            int64_t retval = *reinterpret_cast<int64_t*>(&bytes[pos]);
            pos += sizeof(int64_t);
            return retval;
        }
        return -1;
    }

    uint8_t *readBytes(size_t len) {
        if(checkPos(len)) {
            uint8_t *retval = &bytes[pos];
            pos += len;
            return retval;
        }
        return nullptr;
    }

    /**
     * Reads a string until end_marker is seen
     * @param end_marker Marks the end character until we want to read
     * @return The allocated string
     */
    std::string readString(char end_marker, bool& error) {
        std::vector<char> bytes;
        while(true) {
           int8_t byte = readByte();
           if(byte == -1) {
               error = true;
               return std::string();
           }
           if(byte == end_marker) {
               break;
           }else {
               bytes.push_back((char) byte);
           }
        }
        size_t r_len = bytes.size();
        error = false;
        return std::string(bytes.begin(), bytes.end());
    }
    size_t seek() {
        return pos;
    }
};

char CIFFLoader::error_message_arr[128];
void CIFFLoader::set_error(const char *error_msg) {
    strncpy(error_message_arr, error_msg,128);
}

char *CIFFLoader::error_message() {
    return error_message_arr;
}
CIFFImage *CIFFLoader::from_bytes(uint8_t *bytes, size_t len) {
    ReaderIterator reader(bytes, len);

    uint8_t *magic = reader.readBytes(4);
    if(magic == nullptr) {
        set_error("failed to read magic");
        return nullptr;
    }
    if(strncmp(reinterpret_cast<const char *>(magic),"CIFF",4) != 0) {
        set_error("missing file magic");
        return nullptr;
    }

    int64_t header_size = reader.readLong();
    if(header_size == -1) {
        set_error("failed to read header size");
        return nullptr;
    }

    int64_t content_size = reader.readLong();
    if(content_size == -1) {
        set_error("failed to read content size");
        return nullptr;
    }

    int64_t width = reader.readLong();
    if(width == -1) {
        set_error("failed to read width");
        return nullptr;
    }

    int64_t height = reader.readLong();
    if(height == -1) {
        set_error("failed to read height");
        return nullptr;
    }

    if(width * height * 3 != content_size) {
        set_error("content size != width * height * 3");
        return nullptr;
    }

    bool caption_read_failed = true;
    std::string caption = reader.readString('\n', caption_read_failed);
    if(caption_read_failed) {
        set_error("failed to read caption");
        return nullptr;
    }

    std::vector<std::string> tags;
    uint8_t *content = nullptr;
    bool tag_read_failed = true;
    while(reader.seek() != header_size) {
        std::string tag = reader.readString('\0', tag_read_failed);
        if(tag_read_failed) {
            set_error("failed to read tag");
            return nullptr;
        }
        tags.push_back(tag);
    }

    content = reader.readBytes(content_size);
    if(content == nullptr) {
        set_error("failed to read content");
        return nullptr;
    }

    return new CIFFImage(width, height, caption, tags, content, content_size);
}
CIFFImage *CIFFLoader::from_file(const std::string &path) {
    FILE *f = fopen(path.c_str(), "rb");
    if(!f) {
        set_error("failed to open file");
        return nullptr;
    }
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);  /* same as rewind(f); */

    char *string = new char[fsize];
    fread(string, fsize, 1, f);
    fclose(f);

    return CIFFLoader::from_bytes(reinterpret_cast<uint8_t *>(string), fsize);
}
