#ifndef PLOTLVN_H
#define PLOTLVN_H
#include <QVector>
#include <QMainWindow>
#include <QWidget>
#include <QTextEdit>
#include "qcustomplot.h"
#include "scatterdata.h"


class PlotLvN : public QMainWindow
{
     Q_OBJECT
public:
    PlotLvN(ScatterData& scatterData, QString workDir, QWidget *parent = 0);
    virtual ~PlotLvN();
   // virtual void operator() ();
private:
    void init();
    void populatePlot();
    void writeToPdf();
    QCustomPlot lvNPlot;
    QTextEdit* textEdit;
    ScatterData& scatterData;
    QString workDir;
};

#endif // PLOTLVN_H
