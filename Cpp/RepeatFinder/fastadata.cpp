#include <fstream>
#include <stdexcept>

#include "fastadata.h"
/*
FastaData::FastaData(const string& fastafile)
    : map<string, vector<int>>()
      , sourceFile(fastafile)
{
    init();
}

FastaData::~FastaData()
{
}

long FastaData::getNumBases() const
{
    return numBases;
}

void FastaData::init()
{
   ifstream infasta(sourceFile,  ios_base::in);
   if (infasta.get() != '>')
       throw runtime_error("Assembly fasta does not start with >");

   while (!infasta.eof())
   {
       string contigId;
       std::getline(infasta, contigId);
       infasta.ignore(9999999, '>');
       int contigSize =  infasta.gcount();
       contigSize = contigSize - contigSize/pageWidth; //Remover newlines
       insert( std::make_pair(contigId, vector<int>(contigSize)));
       numBases += contigSize;
   }
}*/
