FROM --platform=x86_64 ubuntu:latest

RUN apt update && apt install -y clang afl++
WORKDIR /app
COPY . .
RUN AFL_USE_LSAN=1 afl-clang-fast++ -o afl_test test_afl.cpp CAFFLoader.cpp CAFFAnimation.cpp CIFFImage.cpp CIFFLoader.cpp && chmod +x afl_test
ENTRYPOINT afl-fuzz -i test_ciff -o caff_fuzz -- ./afl_test --ciff @@