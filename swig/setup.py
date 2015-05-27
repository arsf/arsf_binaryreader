#!/usr/bin/env python

"""
setup.py file for binfile 
"""

from distutils.core import setup, Extension
import os
import numpy

numpy_include=numpy.get_include()

#if windows then statically link the libstdc++ and libgcc - this assumes using mingw32 to compile
if os.name=='nt':
   pass
#   binfile_module = Extension('_las13reader',
#                           sources=['las13reader_wrap.cxx', 'src/Las1_3_handler.cpp',
#                                 'src/Pulse.cpp','src/PulseManager.cpp','src/vec3d.cpp'],
#                           extra_compile_args=["-std=c++0x"],
#                           extra_link_args=["-lstdc++","-lgcc","-static"]
#                           )

else:
   binfile_module = Extension('_binfile',
                           sources=['binfile_wrap.cxx', '../src/bil.cpp',
                                 '../src/bsq.cpp','../src/binaryreader.cpp','../src/binfile.cpp',
                                 '../src/commonfunctions.cpp','../src/multifile.cpp'],
                           extra_compile_args=["-fPIC"],
                           include_dirs=[numpy_include],
                           )

setup (name = 'binfile',
       version = '4.0',
       author      = "arsf",
       description = """binfile swig""",
       ext_modules = [binfile_module],
       py_modules = ["binfile"],
       )

