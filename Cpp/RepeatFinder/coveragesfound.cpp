#include "coveragesfound.h"

CoveragesFound::CoveragesFound(shared_ptr<PointCoverage> pcoverageData//PointCoverage* pcoverageData
                               , unsigned int endSnipSize
                               , bool logarithmic)
    : vector<int>(pcoverageData->getLargestCoverage() + 1)
    , coverageData(pcoverageData)
    , endSnipSize(endSnipSize)
    , logarithmic(logarithmic)
{
    //coverageData.reset(coverageData);
    init();
}

CoveragesFound::~CoveragesFound()
{
}

void CoveragesFound::init()
{

    for ( std::map<string,vector<int>>::const_iterator  contig = coverageData->cbegin()
          ; contig != coverageData->cend()
          ; contig++ )
    {
        if (2*endSnipSize < contig->second.size())
        {
            for ( unsigned int base = endSnipSize
                  ; base < contig->second.size() - endSnipSize
                  ; base++ )
            {
                if (size() <= (size_type) contig->second[base])
                    throw runtime_error("Invalided point coverage");
                (*this)[contig->second[base]] = (*this)[contig->second[base]] + 1;
            }
        }
    }
}
