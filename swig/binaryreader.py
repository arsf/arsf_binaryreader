#!/usr/bin/env python
#-*- coding:utf-8 -*-

import binfile
import numpy

class Binfile(binfile.BinFile):
   def __init__(self, filename):
      binfile.BinFile.__init__(self,filename)
   
      self.lines=self.NumLines()
      self.samples=self.NumSamples()
      self.bands=self.NumBands()
      self.filename=self.GetFileName()
      self.hdrfilename=self.GetHeaderFilename()
      self.filesize=self.GetFileSize()
      self.datasize=self.GetDataSize()
      self.datatype=self.GetDataType()
      self.bufferbytes=self.samples*self.bands*self.datasize

   def Readlines1(self,start,num):
      newbuffer=binfile.uint16Array(self.samples*self.bands)
      cnewbuffer=binfile.charArray(self.bufferbytes)
      self.Readlines(cnewbuffer,start,num)
      #string=binfile.cdata(cnewbuffer,self.samples*self.bands*self.datasize)
      binfile.memmove(newbuffer,cnewbuffer)
      return newbuffer,cnewbuffer
