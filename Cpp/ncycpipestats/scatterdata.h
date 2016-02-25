#ifndef SCATTERDATA_H
#define SCATTERDATA_H
#include <QVector>
#include "quastmetrics.h"
#include "cgalmetrics.h"
#include "recipielist.h"

class ScatterData
{
public:
    ScatterData(CgalMetrics& cgal, QuastMetrics& quast);

public:
    QVector<double> x;
    QVector<double> y;
    QVector<QString> pointLabel;
};

#endif // SCATTERDATA_H
