#include <QPdfWriter>
#include <QMargins>
#include <QTextCursor>
#include <QTextEdit>
#include <QFont>
#include <QPen>
#include <QChar>
#include <QPageSize>
#include <QtDebug>
#include <algorithm>
#include "qcpdocumentobject.h"
#include "plotlvn.h"

/*PlotLvN::PlotLvN(ScatterData& scatterData, QString workDir, QWidget *parent)
    : QMainWindow(parent), scatterData(scatterData), workDir(workDir), recipieList(RecipieList())
{
    width = 800;
    height = 600;
    init();
}*/

PlotLvN::PlotLvN(ScatterData &scatterData, QString workDir, RecipieList &recipie, QWidget *parent)
: QMainWindow(parent), scatterData(scatterData), workDir(workDir), recipieList(recipie)
{
    width = 800;
    height = 600;
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
    resize(width, height);

    textEdit = new QTextEdit;
    setCentralWidget(textEdit);   

    populatePlot();
    AddTextEditHeader();
    AddPlotToTextEdit();


    bool worked = lvNPlot.savePdf(workDir + "fileninameSavePdf.pdf");
    qDebug() << worked;
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
    lvNPlot.xAxis->setRange(*lowerX*0.0, *upperX*1.2);
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

void PlotLvN::AddTextEditHeader()
{
    textEdit->setFont(QFont(font().family(), 30));
    textEdit->insertPlainText(prefix() + " LvsN plot\n\n");
    textEdit->setFont(QFont(font().family(), 16));
    for ( int i=0 ; i<scatterData.x.size() ; i++ )
    {
        QString text = scatterData.pointLabel.at(i);
        QString tag = text.left(2);
        QString name1 = nameFromTag(tag);
        QString insertString = tag + " = " + name1 + "\n";
        qDebug() << text << tag << name1 << insertString;
        textEdit->insertPlainText(insertString);
    }
    textEdit->insertPlainText("\n\n");
}

void PlotLvN::AddPlotToTextEdit()
{
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
    textEdit->setDocumentTitle("lvnp plot title");
}

void PlotLvN::writeToPdf()
{
    QPdfWriter* pdfWriter = new QPdfWriter(workDir + "/LvN75.pdf");
    //QMargins margin = textEdit->contentsMargins();
    //QMargins marginsF(margin);

    //pdfWriter->setPageMargins(marginsF);
    //pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setTitle(prefix() + "Liklyhood vrs N75");
    textEdit->print(pdfWriter);
}

QString PlotLvN::nameFromTag(QString tag) const
{
    QString name;
    QString head = tag.left(tag.size()-1);
    char tail = tag.at(tag.size()-1).cell();

    QVector<RecipieList::Recipie> recipies = recipieList.recipiesData();
    for ( int i = 0 ; i < recipies.size() ; ++i )
    {
        if (recipies.at(i).tag == head)
        {
            name = recipies.at(i).name;
            break;
        }
    }
    switch (tail){
        case 's'  :
           name += " scaffolds";
           break;
        case 'c'  :
           name += " contigs";
           break;
        default :
           ;
    }
    return name;
}

QString PlotLvN::prefix() const
{
    QString text = scatterData.pointLabel.at(0);
    text = text.right(text.size()-2);
    text = text.left(text.size()-1);
    return text;
}






























