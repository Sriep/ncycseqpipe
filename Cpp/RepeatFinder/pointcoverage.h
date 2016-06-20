#ifndef POINTCOVERAGE_H
#define POINTCOVERAGE_H
#include <string>
#include "fastadata.h"

using namespace std;

class PointCoverage : public FastaData<int>
{
public:
    PointCoverage(const string& fastafile, const string& bamfile);

    string getBamfile() const;
    string getFastafile() const;
    long long getTotalCoverage() const;
    long long getMappedReads() const;
    long long getLargestCoverage() const;
    long getUnmappedReads() const;
    long getNonFitttingReads() const; 

private:
    void init();

    string bamfile;
    string fastafile;
    long long totalCoverage = 0;
    long long mappedReads = 0;
    long long largestCoverage = 0;
    std::string contigWithLargestCoverage = "";
    int positionLargestCoverage = 0;
    long unmappedReads = 0;
    long nonFitttingReads = 0;
};

#endif // POINTCOVERAGE_H
