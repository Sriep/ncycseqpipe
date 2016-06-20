#ifndef FASTADATA_H
#define FASTADATA_H

#include <string>
#include <vector>
#include <map>
#include <fstream>
#include <stdexcept>


using namespace std;

template <class T> class FastaData : public map<string, vector<T>>
{
public:
    FastaData(const string& fastafile)
        : map<string, vector<T>>()
          , sourceFile(fastafile)
    {
        init();
    }

    virtual ~FastaData() {}

    long getNumBases() const
    {
        return numBases;
    }

    string getFastaFile() const
    {
        return sourceFile;
    }

private:
    void init()
    {
       ifstream infasta(sourceFile,  ios_base::in);
       char firstch = infasta.get();
       if (firstch != '>')
           throw runtime_error("Assembly fasta does not start with >");

       while (!infasta.eof())
       {
           string contigId;
           std::getline(infasta, contigId,'\n');
           infasta.ignore(9999999, '>');
           int contigSize =  infasta.gcount();
           contigSize = contigSize - contigSize/pageWidth; //Remover newlines
           map<string, vector<T>>::insert( std::make_pair(contigId, vector<T>(contigSize)));
           numBases += contigSize;
       }
    }
protected:
    string sourceFile;
    long numBases = 0;
    int pageWidth = 60;

};



/*
class FastaData : public map<string, vector<int>>
{
public:
    FastaData(const string& fastafile);
    virtual ~FastaData();

    long getNumBases() const;

private:
    void init();

    string sourceFile;
    long numBases = 0;
    int pageWidth = 60;
};*/

#endif // FASTADATA_H
