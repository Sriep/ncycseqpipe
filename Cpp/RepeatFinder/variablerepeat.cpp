#include "variablerepeat.h"
#include <stdexcept>

VariableRepeat::VariableRepeat(const string &contigId
                               , const vector<int> &contigCoverage
                               , const vector<char> contigBases
                               , unsigned int startPos
                               , long long coverageThreshold
                               , long long genomeCoverage
                               , long long numBases)
    : contigId(contigId)
    , startPos(startPos)
    , genomeCoverage(genomeCoverage)
    , numBases(numBases)
    , coverageThreshold(coverageThreshold)
{
    init(contigCoverage, contigBases);
}

VariableRepeat::~VariableRepeat()
{
}

unsigned long VariableRepeat::getEndPos() const
{
    return endPos;
}

int VariableRepeat::getAvRepeatLevel() const
{
    return avRepeatLevel;
}

unsigned int VariableRepeat::size() const
{
    return coverage.size();
}

unsigned long VariableRepeat::getStartPos() const
{
    return startPos;
}

void VariableRepeat::init(const vector<int> &contigCoverage, const vector<char> contigBases)
{
    if (0 != numBases) avCoverage =  genomeCoverage/numBases;
    int totalRepeatLevels = 0;

    unsigned int pos = 0;
    while ( startPos+pos < contigCoverage.size()
            && contigCoverage[startPos+pos] > coverageThreshold)
    {
        coverage.push_back(contigCoverage[startPos+pos]);
        repeatLevel.push_back(contigCoverage[startPos+pos]/avCoverage);
        posInContig.push_back(startPos+pos);
        pos++;
        totalRepeatLevels += contigCoverage[startPos+pos]/avCoverage;
        bases.push_back(contigBases[pos]);
    }
    endPos = startPos+pos;
    if (0 != pos)   avRepeatLevel = totalRepeatLevels/pos;
}

string VariableRepeat::getBases() const
{
    return bases;
}

string VariableRepeat::getContigId() const
{
    return contigId;
}

