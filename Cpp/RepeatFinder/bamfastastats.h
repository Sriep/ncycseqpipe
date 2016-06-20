#ifndef BAMFASTASTATS_H
#define BAMFASTASTATS_H
#include <QTextDocument>

#include "pointcoverage.h"

class BamFastaStats :  public QTextDocument
{
public:
    BamFastaStats(const PointCoverage& coverageData);

private:
     const PointCoverage& coverageData;
};

#endif // BAMFASTASTATS_H
