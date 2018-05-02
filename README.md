# ARSF Binaryreader #

## General Notes ##

This is a simple reader for ENVI binary files (bil,bsq) with accompanying header files. It is not meant as a replacement for GDAL and users are recommended to that library as it is far more fully featured and widely used.

## Licencing information ##

This code is licenced under the GNU General Public Licence (GPL) version 3. A copy of the licence is available with the code.

## Build instructions ##

To build the main C++ library Under linux, run:
```
make all
```
To also build Python bindings follow the [SWIG instructions](swig/README.md).
