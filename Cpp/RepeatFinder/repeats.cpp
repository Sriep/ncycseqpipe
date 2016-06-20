#include "repeats.h"
#include "fassembly.h"

Repeats::Repeats(shared_ptr<PointCoverage> coverageData
                 , int repeatThreshold
                 , int minRepeatSize)
    : vector<std::shared_ptr<VariableRepeat>>()
    , coverageData(coverageData)
    , genomeCoverage(coverageData->getTotalCoverage())
    , numBases(coverageData->getNumBases())
    , repeatThreshold(repeatThreshold)
    , minRepeatSize(minRepeatSize)
{
    if (0 != numBases) avCoverage =  genomeCoverage/numBases;
    init();
}

Repeats::Repeats(const Repeats &rPB, const Repeats &rIll)
    : vector<std::shared_ptr<VariableRepeat>>(rPB)
    , coverageData(rPB.coverageData)
    , genomeCoverage(rPB.genomeCoverage)
    , numBases(rPB.numBases)
    , repeatThreshold(rPB.repeatThreshold)
    , minRepeatSize(rPB.minRepeatSize)
{
    Intersect(rIll);
}

void Repeats::init()
{
    FAssembly fasta(coverageData->getFastaFile());

    for ( std::map<string,vector<int>>::const_iterator  contig = coverageData->cbegin()
          ; contig != coverageData->cend()
          ; contig++ )
    {
        unsigned int base = 0;
        int coverThreshold = avCoverage * repeatThreshold;
        const vector<char> contigBases = fasta[contig->first];
        while(base < contig->second.size())
        {
            int baseCover = contig->second[base];
            if (baseCover > coverThreshold)
            {
                std::shared_ptr<VariableRepeat>
                        repeat (new VariableRepeat(contig->first
                                                  , contig->second
                                                  , contigBases
                                                  , base
                                                  , coverThreshold
                                                  , genomeCoverage
                                                  , numBases));
                if (maxRepeatLevel < repeat->getAvRepeatLevel())
                {
                    maxRepeatLevel = repeat->getAvRepeatLevel();
                    maxRepeat = repeat;
                }
                if (repeat->size() >= minRepeatSize)
                {
                    push_back(repeat);
                }
                base = repeat->getEndPos();
            }
            else
            {
                base++;
            }
        }
    }
}

bool Repeats::IntersetsWith(const VariableRepeat& repeat) const
{
    for ( auto it=begin() ; it != end() ; it++  )
    {
        if ( (**it).getContigId() == repeat.getContigId())
        {
            int isp =(**it).getStartPos();
            int iep = (**it).getEndPos();
            int rsp = repeat.getStartPos();
            int rep = repeat.getEndPos();

            if ( (**it).getStartPos() < repeat.getEndPos()
                 && (**it).getEndPos() > repeat.getStartPos() )
            {
                return true;
            }
        }
    }
    return false;
}

void Repeats::Intersect(const Repeats &rIll)
{
    for ( int i = size()-1 ; i >= 0 ; i-- )
    {
        VariableRepeat& vr = *((*this)[i]);
        if (!rIll.IntersetsWith(vr))
        {
            std::vector<shared_ptr<VariableRepeat>>::iterator iter = begin() + i;
            erase(iter);
        }
    }


}

std::shared_ptr<PointCoverage> Repeats::getCoverageData() const
{
    return coverageData;
}

std::vector<int>  Repeats::repeatsLengths() const
{
    vector<int> rtv;
    for ( auto it=begin() ; it != end() ; it++  )
    {
        rtv.push_back((*it)->size());
    }
    return rtv;
}

std::vector<int>  Repeats::repeatsLevels() const
{
    vector<int> rtv;
    for ( auto it=begin() ; it != end() ; it++  )
    {
        rtv.push_back((*it)->getAvRepeatLevel());
    }
    return rtv;
}


