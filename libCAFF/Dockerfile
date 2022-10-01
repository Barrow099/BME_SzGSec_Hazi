FROM --platform=x86_64 alpine:latest

RUN apk update && apk add g++ cmake afl++
WORKDIR /app
COPY . .
RUN afl-g++ -o afl_test test_afl.cpp CAFFLoader.cpp CAFFAnimation.cpp CIFFImage.cpp CIFFLoader.cpp && chmod +x afl_test
ENTRYPOINT afl-fuzz -i test_images -o caff_fuzz -- ./afl_test --caff @@