#ifndef SCATTERDATA_H
#define SCATTERDATA_H
#include <QVector>
#include <QString>
#include "quastmetrics.h"
#include "cgalmetrics.h"
#include "alemetrics.h"
#include "recipielist.h"

class ScatterData
{
public:
    ScatterData(CgalMetrics& cgal, QuastMetrics& quast);
    ScatterData(AleMetrics &ale, QuastMetrics& quast);

    QString pointLabel(int position) const;
    QString getName() const;

public:
    QVector<double> x;
    QVector<double> y;
    QVector<QString> label;

    QString name;
};

#endif // SCATTERDATA_H
