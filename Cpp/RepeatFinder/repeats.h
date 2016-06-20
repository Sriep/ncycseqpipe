#ifndef REPEATS_H
#define REPEATS_H
#include <memory>
#include <vector>
#include "pointcoverage.h"
#include "variablerepeat.h"

using namespace std;

class Repeats : public vector<shared_ptr<VariableRepeat>>
{
public:
    Repeats(shared_ptr<PointCoverage> coverageData
            , int repeatThreshold = 3
            , int minRepeatSize = 90);
    Repeats(const Repeats& rPB, const Repeats& rIll);

    std::shared_ptr<PointCoverage> getCoverageData() const;
    std::vector<int> repeatsLengths() const;
    std::vector<int>  repeatsLevels() const;

private:
    void init();
    void Intersect(const Repeats& rIll);
    bool IntersetsWith(const VariableRepeat& repeat) const;

    std::shared_ptr<PointCoverage> coverageData;

    long long  genomeCoverage = 0;
    long long  numBases = 1;
    int avCoverage = 0;
    int repeatThreshold = 3;
    int minRepeatSize = 90;

    int maxRepeatLevel = 0;
    shared_ptr<VariableRepeat> maxRepeat;    
};

#endif // REPEATS_H
