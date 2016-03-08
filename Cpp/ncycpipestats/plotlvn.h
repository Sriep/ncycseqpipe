#ifndef PLOTLVN_H
#define PLOTLVN_H
#include <QTextDocument>
#include <QTextDocumentFragment>
#include <QTextBlock>
#include <QString>
#include "scatterdata.h"

class QTextFrame;

class PlotLvN : public QTextDocument
{
public:
    PlotLvN(ScatterData& scatterData
            , QString workDir
            , RecipieList& recipie);

    QTextDocumentFragment  contents();
    void writeToPdf();
    virtual ~PlotLvN();
protected:
    void populateDocument();
    virtual void addGraph(QTextBlock block) = 0;
    QString nameFromTag(QString tag) const;
    QString prefix() const;

    //QTextDocument document;
    ScatterData& scatterData;
    QString workDir;

    int width;
    int height;
private:
    void init();
    void setHeader(QTextBlock block);
    void setLegend(QTextBlock block);
    void setData(QTextCursor cursor);
    void addTextEditHeader();
    void addPlotToTextEdit();

    RecipieList& recipieList;    
    //QTextBlock* header;
    //QTextBlock* legend;
    //QTextBlock* graph;
};

#endif // PLOTLVN_H
