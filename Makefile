# VERSION NUMBER
vers=4.0.0

# Build for windows or linux (note this assumes you are compiling or cross compiling on linux)
BUILDFOR=linux

# Build type 32 or 64 (for linux versions)
TOBUILD=64
SHAREDEXTRA=

ifeq ($(BUILDFOR),linux)
	CPPFLAGS=-Wall -O4 -fPIC -fexceptions
	CC=g++
	AR=ar -cq
	ifeq ($(TOBUILD),32)
      #32 bit build needs large file support
		CPPFLAGS += -m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE -D_LARGEFILE_SOURCE -ffloat-store
		SHAREDEXTRA += -m32
	endif

	SHAREDEXTRA += -lc
	SHARELIBCOMMAND=$(CC) -shared -Wl,-soname,$@ -o $@.$(vers) $^ $(SHAREDEXTRA)
endif

ifeq ($(BUILDFOR),windows)
	CPPFLAGS=-Wall -O4 -fexceptions -D _W32 -ffloat-store -DBUILDING_EXAMPLE_DLL
	ifeq ($(TOBUILD),32)
		CPPFLAGS += -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE -D_LARGEFILE_SOURCE
		CC=i686-w64-mingw32-g++
		AR=i686-w64-mingw32-ar -rcs
		SHAREDEXTRA += -m32
	else
		CC=x86_64-w64-mingw32-g++
		AR=x86_64-w64-mingw32-ar -rcs
	endif

	SHAREDEXTRA += -static -lstdc++
	SHARELIBCOMMAND=$(CC) -shared -Wl,--out-implib,$(libs)/libbinaryreader_dll.a -o $(libs)/libbinaryreader_dll.dll $^ $(SHAREDEXTRA) 
endif

# Object file directory
obj=objectfiles

# source dir
src=src

# lib dir
libs=libs

# file to save dependencies to
dependfile = .depend

# Make all the exes
all: $(dependfile) setupenv $(libs)/libbinaryreader.a $(libs)/libbinaryreader.so

#Set up environment if not already done
setupenv:
	test -d $(obj) || mkdir -p $(obj)
	test -d $(libs) || mkdir -p $(libs)

so: $(libs)/libbinaryreader.so

# make binary reader library (archive)
$(libs)/libbinaryreader.a: $(obj)/binaryreader.o $(obj)/bil.o $(obj)/bsq.o $(obj)/binfile.o $(obj)/multifile.o $(obj)/commonfunctions.o
	rm -f $@
	$(AR) $@ $^

# make binary reader shared library
$(libs)/libbinaryreader.so:  $(obj)/binaryreader.o $(obj)/bil.o $(obj)/bsq.o $(obj)/binfile.o $(obj)/multifile.o $(obj)/commonfunctions.o
#	$(CC) -shared -Wl,-soname,$@ -o $@.$(vers) $^ $(SHAREDEXTRA)
#	$(CC) -shared -Wl,--out-implib,libbinaryreader_dll.a -o libbinaryreader_dll.dll $^ $(SHAREDEXTRA) 
	$(SHARELIBCOMMAND)
	echo
	echo "Do not forget to add the location of the .so file to the LD_LIBRARY_PATH or install it in a directory already in the path."	

clean: 
	rm -f $(obj)/*.o 
	rm -f $(dependfile) 

cleanall: clean
	rm -f $(libs)/*

depend: $(dependfile)

# Get the dependencies for each cpp file and store in dependfile
$(dependfile): $(src)/*.cpp
	rm -f $(dependfile)

	for fname in $(wildcard $(src)/*.cpp) ; do \
		fnameo=`echo $$fname | sed 's/.cpp/.o/' | sed 's/$(src)\///'`;\
		$(CC) -MM -MT $(obj)/$$fnameo $(CPPFLAGS) $$fname -MF $(dependfile) ; \
   done

# These are targets that dont actually exist after the build
.PHONY: clean cleanall all depend

.SUFFIXES:.o .cpp

# make the object file using the equivalent named cpp file and dependencies
# $< means first dependency, $@ means file on the left of :
$(obj)/%.o: $(src)/%.cpp 
	$(CC) $(CPPFLAGS) -c $< -o $@

-include $(dependfile) 
