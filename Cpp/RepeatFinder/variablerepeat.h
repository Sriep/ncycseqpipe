#ifndef REPEAT_H
#define REPEAT_H
#include <string>
#include <vector>
#include "qcustomplot.h"

using namespace std;

class VariableRepeat
{
public:
    VariableRepeat(const string& contigId
                   , const vector<int>& contigCoverage
                   , const vector<char> contigBases
                   , unsigned int startPos
                   , long long coverageThreshold
                   , long long genomeCoverage =0
                   , long long numBases=0);
    virtual ~VariableRepeat();
    VariableRepeat(const VariableRepeat &) = default;
    VariableRepeat(VariableRepeat&&) = default;
    VariableRepeat& operator=(const VariableRepeat&) & = default;
    VariableRepeat& operator=(VariableRepeat&&) & = default;

    string getContigId() const;
    unsigned long getStartPos() const;
    unsigned long getEndPos() const;
    int getAvRepeatLevel() const;
    unsigned int size() const;
    string getBases() const;
    bool IntersetWith(const VariableRepeat& rIll);

private:
    void init(const vector<int> &contigCoverage
              , const vector<char> contigBases);

    string contigId;
    vector<int> coverage;
    vector<int> repeatLevel;
    vector<int> posInContig;
    string bases;


    unsigned long startPos;
    unsigned long endPos;
    long long genomeCoverage;
    long long numBases = 1;
    int coverageThreshold;
    long long avCoverage = 1;
    int avRepeatLevel = 0;
    QCustomPlot cplot;
};

#endif // REPEAT_H
