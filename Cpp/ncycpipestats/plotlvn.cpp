
#include <QPdfWriter>
#include <QMargins>
#include <QTextCursor>
#include <QPdfWriter>
#include <QPageSize>
#include <algorithm>
#include "qcpdocumentobject.h"
#include "plotlvn.h"

PlotLvN::PlotLvN(ScatterData& scatterData, QWidget *parent)
    : QMainWindow(parent), scatterData(scatterData)
{
    init();
}

PlotLvN::~PlotLvN()
{

}

//void PlotLvN::operator()()
//{
//}

void PlotLvN::init()
{
    double width = 800;
    double height = 600;
    resize(width, height);

    textEdit = new QTextEdit;
    setCentralWidget(textEdit);

    populatePlot();
    // register the plot document object (only needed once, no matter how many
    // plots will be in the QTextDocument):
    QCPDocumentObject *plotObjectHandler = new QCPDocumentObject(this);
    textEdit->document()->documentLayout()->
          registerHandler(QCPDocumentObject::PlotTextFormat, plotObjectHandler);

    QTextCursor cursor = textEdit->textCursor();
    // insert the current plot at the cursor position.
    // QCPDocumentObject::generatePlotFormat creates a
    // vectorized snapshot of the passed plot (with the specified width
    // and height) which gets inserted  into the text document.
    //double width = ui->cbUseCurrentSize->isChecked() ? 0 : ui->sbWidth->value();
    //double height = ui->cbUseCurrentSize->isChecked() ? 0 : ui->sbHeight->value();
    cursor.insertText(QString(QChar::ObjectReplacementCharacter)
                      , QCPDocumentObject::generatePlotFormat(&lvNPlot, width, height));
    textEdit->setTextCursor(cursor);
    
    writeToPdf();
}

void PlotLvN::populatePlot()
{
    lvNPlot.addGraph();
    lvNPlot.graph(0)->setData(scatterData.x, scatterData.y);

    lvNPlot.xAxis->setLabel("N75");
    lvNPlot.yAxis->setLabel("Liklyhood");
    auto upperX = std::max_element(scatterData.x.begin(), scatterData.x.end());
    auto lowerX = std::min_element(scatterData.x.begin(), scatterData.x.end());
    auto upperY = std::max_element(scatterData.y.begin(), scatterData.y.end());
    auto lowerY = std::min_element(scatterData.y.begin(), scatterData.y.end());
    lvNPlot.xAxis->setRange(*lowerX*0.0, *upperX*1.05);
    lvNPlot.yAxis->setRange(*lowerY*1.05, *upperY*0.95);
    lvNPlot.replot();

    lvNPlot.graph(0)->setPen(QColor(50, 50, 50, 255));
    lvNPlot.graph(0)->setLineStyle(QCPGraph::lsNone);
    lvNPlot.graph(0)->setScatterStyle(QCPScatterStyle(QCPScatterStyle::ssDisc, 8));
    lvNPlot.graph(0)->setName("Liklyhood vrs N75");

    for ( int i=0 ; i<scatterData.x.size() ; i++ )
    {
        QCPItemText *textLabel = new QCPItemText(&lvNPlot);
        lvNPlot.addItem(textLabel);
        textLabel->setPositionAlignment(Qt::AlignTop|Qt::AlignHCenter);
        textLabel->position->setType(QCPItemPosition::ptPlotCoords );
        textLabel->position->setCoords(scatterData.x.at(i), scatterData.y.at(i));
        textLabel->setText(scatterData.pointLabel.at(i).left(2));
        textLabel->setFont(QFont(font().family(), 16)); // make font a bit larger
        textLabel->setPen(QPen(Qt::black)); // show black border around text
    }
    lvNPlot.replot();
}

void PlotLvN::writeToPdf()
{
    QPdfWriter* pdfWriter = new QPdfWriter("fileNameLvN5.pdf");
    QMargins margin = textEdit->contentsMargins();
    QMargins marginsF(margin);

    pdfWriter->setPageMargins(marginsF);
    pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setTitle("Liklyhood vrs N75");
    textEdit->print(pdfWriter);
}
































