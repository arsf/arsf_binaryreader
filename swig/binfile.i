//binfile interface file for swig
%module binfile
%{
#define SWIG_FILE_WITH_INIT
#include "../src/binfile.h"
#include "../src/binaryreader.h"
static PyObject* pMyException;
%}

//Initialise the exception object for the BRexception catching
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

//Add function support for creating arrays of certain data types - may not be required anymore since we are using numpy now.
%include "carrays.i"
%include "cdata.i"
%array_class(char, charArray);
%array_class(unsigned short int,uint16Array);
%array_class(double, doubleArray);

//Add exception support for strings and const char* 
%catches(std::string,const char *,...);
%typemap(throws) const char * %{
   PyErr_SetString(PyExc_RuntimeError, $1);
   SWIG_fail;
%}
%typemap(throws) std::string %{
   PyErr_SetString(PyExc_RuntimeError, $1.c_str());
   SWIG_fail;
%}

//The numpy interface file
%include "numpy.i"

//Initialise for numpy
%init %{
   import_array();
%}

//This converts char* to numpy arrays in the wrapper - but fails to compile because the dimension is not specified.
//Using the double* ARGOUT_ARRAY requires a dimension to be given and would (maybe) require wrapping all function calls to remove this.
//So we use the first method and apply a patch to the generated wrapped code to get the dimension from the BinFile methods.
%apply (double ARGOUT_ARRAY1[ANY]){(char* chdata)}

//Ignore the default constructor that takes no input
%ignore BinFile();

//Exception wrapper to convert BRexceptions into a python catchable exception (using runtime errors here)
%exception{
   try
   {
      $action
   }
   catch(BinaryReader::BRexception &br)
   {
      SWIG_exception(SWIG_RuntimeError, (std::string(br.what())+br.info).c_str());
   }
}

//Load in the binfile interface
%include "../src/binfile.h"
