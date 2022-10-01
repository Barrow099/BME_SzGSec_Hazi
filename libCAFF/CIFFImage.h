//
// Created by Barrow099 on 2022. 09. 30..
//

#ifndef LIBCAFF_CIFFIMAGE_H
#define LIBCAFF_CIFFIMAGE_H


#include <cstdint>
#include <string>
#include <vector>
#include <cstring>
class CIFFImage {
private:
    int64_t width;
    int64_t height;
    char *caption;
    char **tags;
    size_t num_of_tags;
    int64_t content_size;
    uint8_t *content;

public:
    CIFFImage(int64_t width, int64_t height, const std::string &caption, const std::vector<std::string> &tags, uint8_t *content, int64_t content_size) : width(width),
                                                                                                                                                         height(height),
                                                                                                                                                         content_size(content_size)
    {
        this->content = new uint8_t[content_size];
        memcpy(this->content, content, content_size);
        this->caption = new char[caption.size() + 1];
        strcpy(this->caption, caption.c_str());

        this->tags = new char*[tags.size()];
        size_t index = 0;
        for (const auto &item: tags) {
            this->tags[index] = new char[item.size() + 1];
            strcpy(this->tags[index], item.c_str());
            index++;
        }
        num_of_tags = index;
    }

    int64_t getWidth() const {
        return width;
    }
    int64_t getHeight() const {
        return height;
    }

    int64_t getContent_size() const {
        return content_size;
    }

    uint8_t* getContent() const {
        return this->content;
    }

    char *getCaption() const{
        return caption;
    }

    size_t getTag_count() const{
        return num_of_tags;
    }

    char **getTags() const{
        return tags;
    }

    virtual ~CIFFImage() {
        delete[] this->content;
        this->content = nullptr;
        delete[] this->caption;
        this->caption = nullptr;

        for(size_t index = 0; index < num_of_tags; index++) {
            delete[] this->tags[index];
        }
        delete[] this->tags;
        this->tags = nullptr;
    }
};


#endif//LIBCAFF_CIFFIMAGE_H
