#ifndef VIEWREPEATS_H
#define VIEWREPEATS_H
#include <QTextDocument>
#include <QTextBlock>
#include <QString>
#include <qmap.h>
#include "repeats.h"
#include "qcustomplot.h"

class ViewRepeats : public QTextDocument
{
public:
    ViewRepeats(shared_ptr<Repeats> repeats);
    virtual ~ViewRepeats();
    ViewRepeats(const ViewRepeats &) = default;
    ViewRepeats(ViewRepeats&&) = default;
    ViewRepeats& operator=(const ViewRepeats&) & = default;
    ViewRepeats& operator=(ViewRepeats&&) & = default;

    void writeRepeats(QString filename);
    void wtireToPdf(QString filename);

private:
    void init();
    virtual void populateDocument();
    virtual void setHeader(QTextBlock block);
    virtual void setPara1(QTextBlock block);
    virtual void addGraph(QTextBlock block);
    virtual void plotNumberEachLength();
    virtual void plotRepeatsEachLength();
    virtual void repeatTable(QTextCursor cursor);

    shared_ptr<Repeats> repeats;
    int width = 800;
    int height = 600;
    QCustomPlot cplot;

    QVector<int> repeatlengths;
    QVector<int> repeatlevels;
    QMap<int, int> countRLenghs;
    QMap<int, int> countRLevels;
};

#endif // VIEWREPEATS_H
