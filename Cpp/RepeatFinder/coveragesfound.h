#ifndef COVERAGESFOUND_H
#define COVERAGESFOUND_H
#include <vector>
#include <memory>
#include "pointcoverage.h"

using namespace std;

class CoveragesFound : public vector<int>
{
public:
    CoveragesFound(shared_ptr<PointCoverage> coverageData
                   , unsigned int endSnipSize = 0
                   , bool logarithmic = true);
    virtual ~CoveragesFound();


private:
     void init();

    //const PointCoverage& coverageData;
    std::shared_ptr<PointCoverage> coverageData;
    unsigned int endSnipSize = 0;
    bool logarithmic = true;
};

#endif // COVERAGESFOUND_H
