#ifndef PLOTLVN_H
#define PLOTLVN_H
#include <QVector>
#include <QMainWindow>
#include <QWidget>
#include <QTextEdit>
#include <QTextDocument>
#include <QString>
#include "qcustomplot.h"
#include "scatterdata.h"


class PlotLvN
{
public:
    PlotLvN(ScatterData& scatterData
            , QString workDir
            , RecipieList& recipie);
    void writeToPdf();
    virtual ~PlotLvN();
private:
    void init();
    void populateDocument();
    void setHeader(QTextBlock block);
    void setLegend(QTextBlock block);
    void setGraph(QTextBlock block);
    void populatePlot();
    void addTextEditHeader();
    void addPlotToTextEdit();

    QString nameFromTag(QString tag) const;
    QString prefix() const;

    QCustomPlot lvNPlot;
    QTextDocument document;
    QTextBlock* header;
    QTextBlock* legend;
    QTextBlock* graph;
    ScatterData& scatterData;
    QString workDir;
    RecipieList& recipieList;

    int width;
    int height;
};

#endif // PLOTLVN_H
