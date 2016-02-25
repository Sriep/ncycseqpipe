#ifndef PLOTLVN_H
#define PLOTLVN_H
#include <QVector>
#include <QMainWindow>
#include <QWidget>
#include <QTextEdit>
#include <QString>
#include "qcustomplot.h"
#include "scatterdata.h"


class PlotLvN : public QMainWindow
{
     Q_OBJECT
public:
    //PlotLvN(ScatterData& scatterData, QString workDir, QWidget *parent = 0);
    PlotLvN(ScatterData& scatterData
            , QString workDir
            , RecipieList& recipie
            , QWidget *parent = 0);
    virtual ~PlotLvN();
   // virtual void operator() ();
private:
    void init();
    void populatePlot();
    void AddTextEditHeader();
    void AddPlotToTextEdit();
    void writeToPdf();
    QString nameFromTag(QString tag) const;
    QString prefix() const;

    QCustomPlot lvNPlot;
    QTextEdit* textEdit;
    ScatterData& scatterData;
    QString workDir;
    RecipieList& recipieList;

    int width;
    int height;
};

#endif // PLOTLVN_H
