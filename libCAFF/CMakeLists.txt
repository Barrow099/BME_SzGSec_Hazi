cmake_minimum_required(VERSION 3.23)
project(libCAFF)

set(CMAKE_CXX_STANDARD 14)

add_library(CAFF SHARED CIFFImage.cpp CIFFImage.h CIFFLoader.cpp CIFFLoader.h CIFFWriter.cpp CIFFWriter.h capi.h capi.cpp CAFFAnimation.cpp CAFFAnimation.h CAFFLoader.cpp CAFFLoader.h test_afl.cpp)
add_executable(caff_test exe_test.cpp)
add_executable(dyn_test test_dyn.c)
add_executable(afl_test test_afl.cpp)
add_executable(caff_preview preview.cpp)
target_link_libraries(caff_test CAFF)
target_link_libraries(caff_preview CAFF)
target_link_libraries(afl_test ubsan CAFF)
target_compile_options(afl_test PRIVATE -fsanitize=undefined)
