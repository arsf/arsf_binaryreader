swig -python -c++ binfile.i
patch binfile_wrap.cxx < patch
python setup.py build_ext
