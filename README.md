## Native parser

All of the parser code resides inside the `libCAFF` directory. The implementation contains a full CAFF and CIFF parser in C++ and a C API for FFI.

Run `make all` from the libCAFF directory. The built binaries will be placed inside libCAFF/build folder. The `caff_preview` binary can be used to generate preview files from .CAFF animations. The preview as RGB8 and the image size info will be written to two files.

The repository contains other folders, they are not part of the native parser implementation.