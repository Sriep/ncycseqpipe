#ifndef CPPLOTLVN_H
#define CPPLOTLVN_H
#include "plotlvn.h"
#include "qcustomplot.h"

class CPPlotLvN : public PlotLvN
{
public:

    CPPlotLvN(ScatterData& scatterData, QString workDir, RecipieList& recipie);
    virtual ~CPPlotLvN();
protected:
    virtual void addGraph(QTextBlock block);

private:
    void populatePlot();

    QCustomPlot lvNPlot;
};

#endif // CPPLOTLVN_H
