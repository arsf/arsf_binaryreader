# ARSF Binaryreader SWIG Bindings #

## General Notes ##

These are SWIG bindings to generate a python wrapper for the c++ library. You will require the numpy.i interface file (from numpy code distribution).

You can download this from https://raw.githubusercontent.com/numpy/numpy/master/tools/swig/numpy.i

## Build Instructions ##

These commands should build a working version of the python library. Note that a patch is required probably because the binfile.i interface is not as good as it could be.

```
swig -python -c++ binfile.i
patch binfile_wrap.cxx < patch
python setup.py build_ext
```

To install the library use:
```
python setup.py install
```
This will try to install to the default location for Python packages, which may require being run as sudo.

To specify a location to install to set using the `--prefix` flag.

```
python setup.py install --prefix <install location>
```
