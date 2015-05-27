//binfile interface file for swig
%module binfile
%{
#define SWIG_FILE_WITH_INIT
#include "../src/binfile.h"
#include "../src/binaryreader.h"
static PyObject* pMyException;
%}

%init %{
   pMyException = PyErr_NewException("_binfile.BRexception",NULL,NULL);
   Py_INCREF(pMyException);
   PyModule_AddObject(m,"BRexception",pMyException);
%}

//Load in some standard types
%include "typemaps.i"
//Allow strings
%include "std_string.i"
%include "exception.i"
//Allow std:maps
%include "std_map.i"
//Allow types like uint64_t
%include "stdint.i"

%include "carrays.i"
%include "cdata.i"
%array_class(char, charArray);
%array_class(unsigned short int,uint16Array);
%array_class(double, doubleArray);

%catches(std::string,const char *,...);

%typemap(throws) const char * %{
   PyErr_SetString(PyExc_RuntimeError, $1);
   SWIG_fail;
%}
%typemap(throws) std::string %{
   PyErr_SetString(PyExc_RuntimeError, $1.c_str());
   SWIG_fail;
%}

%include "numpy.i"

%init %{
   import_array();
%}

%apply (double ARGOUT_ARRAY1[ANY]){(char* chdata)}
//void BinFile::Readlines(char* const ARGOUT_ARRAY1,int DIM1, unsigned int startline,unsigned int numlines);


//Ignore the default constructor that takes no input
%ignore BinFile();

%exception{
   try
   {
      $action
   }
   catch(BRexception &br)
   {
      SWIG_exception(SWIG_RuntimeError, (std::string(br.what())+br.info).c_str());
   }
}

//Load in the binfile interface
%include "../src/binfile.h"
%include "../src/binfile.h"
