#include "fassembly.h"
#include <fstream>
#include <stdexcept>
#include "main.h"
#include <ctype.h>

FAssembly::FAssembly(const string &fastafile)
    : FastaData(fastafile)
{
    init();
}

void FAssembly::init()
{
    ifstream infasta(sourceFile,  ios_base::in);
    if (infasta.get() != '>')
        throw runtime_error("Assembly fasta does not start with >");

    while (!infasta.eof())
    {
        string contigId;
        std::getline(infasta, contigId);
        std::map<string, vector<char>>::iterator it = find(contigId);
        if (it == end()) throw std::logic_error("contig Id missing");

        string contigWithNewLines;
        std::getline(infasta, contigWithNewLines, '>');
        string contigBases = removeChar(contigWithNewLines, '\n');
        it->second.resize(contigBases.size());

        for ( unsigned int pos = 0 ; pos < contigBases.size() ; pos++ )
        {
            char nextBase = toupper(contigBases[pos]);
            if (nextBase != '\n')
            {
               it->second[pos] = nextBase;
            }

        }
    }
}
