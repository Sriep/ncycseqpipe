#include <QTextCursor>
#include <QTextDocumentFragment>
#include <QTextBlockFormat>
#include <QFile>
#include <algorithm>
#include <memory>
#include "qcpdocumentobject.h"
#include "viewrepeats.h"
#include "main.h"


ViewRepeats::ViewRepeats(shared_ptr<Repeats> repeats)
    : QTextDocument(), repeats(repeats)
{

    init();
}

ViewRepeats::~ViewRepeats()
{
}

void ViewRepeats::writeRepeats(QString filename)
{
    QFile outf(filename);
    if ( outf.open(QIODevice::WriteOnly) )
    {
        QTextStream stream(&outf);
        for ( int i = 0 ; i < (*repeats).size() ; i++ )
        {
            stream << ">Repeat" + QString::number(i) + "\n";
            stream << QString::fromStdString((*repeats)[i]-> getBases());
            stream << "\n";
        }
    }
}

void ViewRepeats::wtireToPdf(QString filename)
{
    if (isEmpty()) populateDocument();
    QPdfWriter* pdfWriter = new QPdfWriter(filename);
    pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setPageOrientation(QPageLayout::Landscape);
    pdfWriter->setTitle("Repeats");
    print(pdfWriter);
}

void ViewRepeats::init()
{
    repeatlengths = QVector<int>::fromStdVector(repeats->repeatsLengths());
    repeatlevels = QVector<int>::fromStdVector(repeats->repeatsLevels());

    for ( int i = 0 ; i < repeatlengths.size() ; i++ )
    {
        int rli = repeatlengths[i];
        if (countRLenghs.find(rli) == countRLenghs.end())
        {
            countRLenghs[rli] = 1;
            countRLevels[rli] = repeatlevels[i];
        }
        else
        {
            countRLenghs[rli] = countRLenghs[rli] +1;
            countRLevels[rli] = countRLevels[rli] + repeatlevels[i];
        }
    }
    // register the plot document object (only needed once, no matter how many
    // plots will be in the QTextDocument):
    QCPDocumentObject *plotObjectHandler = new QCPDocumentObject();
    QTextDocument::documentLayout()->
            registerHandler(QCPDocumentObject::PlotTextFormat, plotObjectHandler);
}

void ViewRepeats::populateDocument()
{
    setHeader(firstBlock());

    QTextCursor cursor(this);
    cursor.movePosition(QTextCursor::End);
    cursor.insertBlock();

    setPara1(lastBlock());

    cursor.movePosition(QTextCursor::End);
    cursor.insertBlock();

    QTextBlockFormat format = cursor.blockFormat();
    format.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysAfter);
    cursor.setBlockFormat(format);

    plotNumberEachLength();
    addGraph(lastBlock());

    cursor.movePosition(QTextCursor::End);
    cursor.insertBlock();

    plotRepeatsEachLength();
    addGraph(lastBlock());
    cursor.movePosition(QTextCursor::End);

    cursor.movePosition(QTextCursor::End);
    repeatTable(cursor);
}

void ViewRepeats::setHeader(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    QTextCharFormat headerCharF = block.charFormat();
    headerCharF.setFontPointSize(30);
    headerCharF.setFontWeight(QFont::Bold);
    cursor.setBlockCharFormat(headerCharF);

    QString header= "Repeats \n" ;
    QTextDocumentFragment headerFrag
            = QTextDocumentFragment::fromPlainText(header);
    cursor.insertFragment(headerFrag);

    headerCharF.setFontPointSize(14);
    headerCharF.setFontWeight(QFont::Normal);
    cursor.setBlockCharFormat(headerCharF);
    //headerFrag = QTextDocumentFragment::fromPlainText(scatterData.getName() + "\n");
    //cursor.insertFragment(headerFrag);
}

void ViewRepeats::setPara1(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    cursor.insertText("bamfile: "
                      + QString::fromStdString(
                          repeats->getCoverageData()->getBamfile()
                      + "\n"));
    cursor.insertText("assembly file: "
                      + QString::fromStdString(
                          repeats->getCoverageData()->getFastaFile()
                      + "\n"));
    cursor.insertText(" total number of bases: "
                      + QString::number(repeats->getCoverageData()->getNumBases())
                      +"\n");
    cursor.insertText(" total number mapped reads: "
                      + QString::number(repeats->getCoverageData()->getMappedReads())
                      +"\n");
    cursor.insertText(" Total coverage (sum read lenghts): "
                      + QString::number(repeats->getCoverageData()->getTotalCoverage())
                      +"\n");
    cursor.insertText(" Largest coverage: "
                      + QString::number(repeats->getCoverageData()->getLargestCoverage())
                      +"\n");
    cursor.insertText(" Unmapped reads: "
                      + QString::number(repeats->getCoverageData()->getUnmappedReads())
                      +"\n");
    cursor.insertText(" Reads not fitting to contig: "
                      + QString::number(repeats->getCoverageData()->getNonFitttingReads())
                      +"\n");

}

void ViewRepeats::addGraph(QTextBlock block)
{

    // register the plot document object (only needed once, no matter how many
    // plots will be in the QTextDocument):
    QCPDocumentObject *plotObjectHandler = new QCPDocumentObject();
    QTextDocument::documentLayout()->
          registerHandler(QCPDocumentObject::PlotTextFormat, plotObjectHandler);

    QTextCursor cursor=QTextCursor(block);
    // insert the current plot at the cursor position.
    // QCPDocumentObject::generatePlotFormat creates a
    // vectorized snapshot of the passed plot (with the specified width
    // and height) which gets inserted  into the text document.
    cursor.insertText(QString(QChar::ObjectReplacementCharacter)
                      , QCPDocumentObject::generatePlotFormat(&cplot
                                                              , width
                                                              , height));

    QString filename = "/home/piers/Documents/C++/Data/autoDocs/graph";
    cplot.savePdf(filename + ".pdf" ,false , width, height);
    cplot.savePng(filename + ".png" ,false , width, height);
    cplot.saveJpg(filename + ".jpg" ,false , width, height);
    cplot.saveBmp(filename + ".bmp" ,false , width, height);
}

void ViewRepeats::plotNumberEachLength()
{
    cplot.addGraph();

    QVector<int> l = QVector<int>::fromList(countRLenghs.keys());
    QVector<int> nl =  QVector<int>::fromList(countRLenghs.values());
    QVector<double> lengths = vectorInt2VectorDouble(l);
    QVector<double> numAtLengh(vectorInt2VectorDouble(nl));


    cplot.xAxis->setLabel("length of repeat");
    cplot.yAxis->setLabel("number of repeats");

    QVector<double>::iterator minY = std::min_element(numAtLengh.begin(), numAtLengh.end());
    QVector<double>::iterator maxY = std::max_element(numAtLengh.begin(), numAtLengh.end());
    cplot.xAxis->setRange(0, lengths.size() +1);
    cplot.yAxis->setRange(0, *maxY+1 );

    // prepare x axis with country labels:
    QVector<double> ticks;
    for ( int i = 1 ; i <= lengths.size() ; i++ )
        ticks.push_back(i);
    QVector<QString> labels;
    for ( int i = 0 ; i < lengths.size() ; i++ )
        labels.push_back(QString::number(lengths[i]));

    cplot.xAxis->setAutoTicks(false);
    cplot.xAxis->setAutoTickLabels(false);
    cplot.xAxis->setAutoTickStep(false);
    cplot.xAxis->setTickVector(ticks);
    cplot.xAxis->setTickVectorLabels(labels);
    cplot.xAxis->setTickStep(1);
    cplot.xAxis->setTickLabelRotation(90);
    cplot.xAxis->setSubTickCount(0);
    cplot.xAxis->setAutoTickCount(3);
    cplot.xAxis->setTickLength(0, 4);
    //cplot.xAxis->grid()->setVisible(true);
    cplot.xAxis->setRange(0, 60);

    // Add data:
    QCPBars* repeatLevelBars = new QCPBars(cplot.xAxis, cplot.yAxis);
    repeatLevelBars->setWidthType(QCPBars::wtAxisRectRatio);
    repeatLevelBars->setWidth(0.018);
    repeatLevelBars->setPen(Qt::NoPen);
    repeatLevelBars->setBrush(QColor(100, 180, 110));

    cplot.addPlottable(repeatLevelBars);
    repeatLevelBars->addData(ticks, numAtLengh);

    cplot.replot();
}

void ViewRepeats::plotRepeatsEachLength()
{
    cplot.addGraph();

    QVector<int> lengths = QVector<int>::fromList(countRLenghs.keys());
    QVector<int> nl =  QVector<int>::fromList(countRLenghs.values());
    QVector<int> rps = QVector<int>::fromList(countRLevels.values());
    //QVector<double> lengths = vectorInt2VectorDouble(l);
    //QVector<double> numAtLengh(vectorInt2VectorDouble(nl));
    QVector<double> repeatsAtLenght (rps.size());
    for ( int i=0 ; i < rps.size() ; i++ )
    {
        repeatsAtLenght[i] = nl[i] * rps[i];
    }


    cplot.xAxis->setLabel("length of repeat");
    cplot.yAxis->setLabel("total repeat level of repeats");
    //cplot.xAxis->setRange(0, 58);
    //cplot.yAxis->setRange(0, 5);

    QVector<double>::iterator minY = std::min_element(repeatsAtLenght.begin(), repeatsAtLenght.end());
    QVector<double>::iterator maxY = std::max_element(repeatsAtLenght.begin(), repeatsAtLenght.end());
    cplot.xAxis->setRange(0, lengths.size() +1);
    cplot.yAxis->setRange(0, *maxY +1);

    // prepare x axis with country labels:
    QVector<double> ticks;
    for ( int i = 1 ; i <= lengths.size() ; i++ )
        ticks.push_back(i);
    QVector<QString> labels;
    for ( int i = 0 ; i < lengths.size() ; i++ )
        labels.push_back(QString::number(lengths[i]));

    cplot.xAxis->setAutoTicks(false);
    cplot.xAxis->setAutoTickLabels(false);
    cplot.xAxis->setAutoTickStep(false);
    cplot.xAxis->setTickVector(ticks);
    cplot.xAxis->setTickVectorLabels(labels);
    cplot.xAxis->setTickStep(1);
    cplot.xAxis->setTickLabelRotation(90);
    cplot.xAxis->setSubTickCount(0);
    cplot.xAxis->setAutoTickCount(3);
    cplot.xAxis->setTickLength(0, 4);
    //cplot.xAxis->grid()->setVisible(true);
    cplot.xAxis->setRange(0, 60);

    // Add data:
    QCPBars* repeatLevelBars = new QCPBars(cplot.xAxis, cplot.yAxis);
    repeatLevelBars->setWidthType(QCPBars::wtAxisRectRatio);
    repeatLevelBars->setWidth(0.018);
    repeatLevelBars->setPen(Qt::NoPen);
    repeatLevelBars->setBrush(QColor(180, 90, 90));

    cplot.addPlottable(repeatLevelBars);
    repeatLevelBars->addData(ticks, repeatsAtLenght);

    cplot.replot();
}

void ViewRepeats::repeatTable(QTextCursor cursor)
{
    cursor.insertTable((*repeats).size()+1 ,5);
    cursor.insertText("Contig Id");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Length bps");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Repeats");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Start Pos");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("End Pos");
    cursor.movePosition(QTextCursor::NextCell);
    for ( unsigned int i=0 ; i < (*repeats).size() ; i++ )
    {
        shared_ptr<VariableRepeat> pvr = (*repeats)[i];
        if (!pvr) throw runtime_error("Missing Varaible repeat object");

        cursor.insertText(QString::fromStdString(pvr->getContigId()));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(QString::number(pvr->size()));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(QString::number(pvr->getAvRepeatLevel()));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(QString::number(pvr->getStartPos()));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(QString::number(pvr->getEndPos()));
        cursor.movePosition(QTextCursor::NextCell);
    }
}































