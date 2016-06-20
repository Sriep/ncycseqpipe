#ifndef FASSEMBLY_H
#define FASSEMBLY_H
#include <string>
#include "fastadata.h"

class FAssembly : public FastaData<char>
{
public:
    FAssembly(const string& fastafile);
private:
    void init();
};

#endif // FASSEMBLY_H
