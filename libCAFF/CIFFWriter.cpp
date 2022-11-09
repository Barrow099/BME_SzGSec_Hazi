//
// Created by Barrow099 on 2022. 09. 30..
//

#include "CIFFWriter.h"

class BinWriter {
private:
    std::vector<uint8_t> &data;

public:
    explicit BinWriter(std::vector<uint8_t> &data) : data(data) {}

    void writeBytes(uint8_t *bytes, size_t n) {
        for (size_t i = 0; i < n; i++) {
            data.push_back(bytes[i]);
        }
    }
    void writeLong(int64_t v) {
        uint8_t *bytes = reinterpret_cast<uint8_t *>(&v);
        for (size_t i = 0; i < sizeof(int64_t); i++) {
            data.push_back(bytes[i]);
        }
    }
    void writeString(char *string, char end_mark) {
        size_t len = strlen(string);
        for (size_t i = 0; i < len; i++) {
            data.push_back(string[i]);
        }
        data.push_back(end_mark);
    }
};

std::vector<uint8_t> CIFFWriter::to_bytes(CIFFImage *image) {
    std::vector<uint8_t> bytes;
    BinWriter writer(bytes);
    // Header
    writer.writeBytes((uint8_t *) "CIFF", 4);

    size_t caption_size = strlen(image->getCaption()) + 1;
    size_t tag_size = 0;
    char **tags = image->getTags();
    for (int i = 0; i < image->getTag_count(); ++i) {
        tag_size += strlen(tags[i]) + 1;
    };
    size_t header_size = 36 + caption_size + tag_size;
    writer.writeLong((int64_t) header_size);
    writer.writeLong(image->getContent_size());

    writer.writeLong(image->getWidth());
    writer.writeLong(image->getHeight());
    writer.writeString(image->getCaption(), '\n');

    for (int i = 0; i < image->getTag_count(); ++i) {
        writer.writeString(tags[i], '\0');
    };


    // Body
    writer.writeBytes(image->getContent(), image->getContent_size());
    return bytes;
}
void CIFFWriter::write_to_file(CIFFImage *image, const std::string &file_name) {
    FILE *out = fopen(file_name.c_str(), "wb");
    auto bytes = CIFFWriter::to_bytes(image);
    fwrite(bytes.data(), 1, bytes.size(), out);
    fclose(out);
}
