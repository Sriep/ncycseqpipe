#include <QTextBlockFormat>

#include "qcpdocumentobject.h"
#include "strainpipedata.h"
#include "scatterdata.h"
#include "cpplotlvn.h"




StrainPipeData::StrainPipeData()
    : QTextDocument(), directory(), base_dir()
{
}

StrainPipeData::~StrainPipeData()
{

}

StrainPipeData::StrainPipeData(const QFileInfo &directory)
    : QTextDocument(), directory(directory), base_dir(directory.absoluteFilePath())
{
    if (directory.exists()) init();
}

bool StrainPipeData::valid() const
{
    return directory.exists()
            && (bool) recipie
            && (bool) questMetrics
            && (bool) cgalMetrics
            && (bool) aleMetrics
            && (bool) runTimes;

}

void StrainPipeData::writeToPdf()
{
    if (isEmpty()) populate();
    QString pdfFilename = directory.absoluteFilePath() + "/StrainInfo" + ".pdf";
    QPdfWriter* pdfWriter = new QPdfWriter(pdfFilename);
    pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setTitle("Directory iformation");
    print(pdfWriter);
}

QTextDocumentFragment StrainPipeData::contents()
{
    if (!valid()) return QTextDocumentFragment();
    if (isEmpty()) populate();
    QTextCursor cursor(this);
    cursor.movePosition(QTextCursor::Start, QTextCursor::MoveAnchor);
    cursor.movePosition(QTextCursor::End, QTextCursor::KeepAnchor);
    return cursor.selection();
}

void StrainPipeData::init()
{
    QFileInfo recipefi(directory.absoluteFilePath() + "/logdir/1.RECIPEFILE");
    recipefi.exists() ? recipie.reset(new RecipieList(recipefi))
                      : recipie.reset(new RecipieList());

    base_dir.setNameFilters(QStringList("metric_*quast.csv"));
    QFileInfoList quastFiles=base_dir.entryInfoList();
    quastFiles.empty() ? questMetrics.reset(new QuastMetrics())
                       : questMetrics.reset(new QuastMetrics(quastFiles.first()));


    base_dir.setNameFilters(QStringList("metric_*cgal.csv"));
    QFileInfoList cgalFiles = base_dir.entryInfoList();
    cgalFiles.empty() ? cgalMetrics.reset(new CgalMetrics())
                      : cgalMetrics.reset(new CgalMetrics(cgalFiles.first()));

    base_dir.setNameFilters(QStringList("metric_*ale.csv"));
    QFileInfoList aleFiles=base_dir.entryInfoList();
    aleFiles.empty() ? aleMetrics.reset(new AleMetrics())
                     : aleMetrics.reset(new AleMetrics(aleFiles.first()));


    QString timesFilename = base_dir.absolutePath()
            + "/logdir/1stats/allstats.csv";
    QFileInfo tfi(timesFilename);
    tfi.exists() ? runTimes.reset(new RunTimes(tfi
                                               , base_dir.dirName()
                                               , directory.absolutePath()))
                 : runTimes.reset(new RunTimes());


    // register the plot document object (only needed once, no matter how many
    // plots will be in the QTextDocument):
    QCPDocumentObject *plotObjectHandler = new QCPDocumentObject();
    QTextDocument::documentLayout()->
          registerHandler(QCPDocumentObject::PlotTextFormat, plotObjectHandler);

}

void StrainPipeData::populate()
{
    if (!valid()) return;

    header(firstBlock());

    QTextCursor cursor(this);
    cursor.movePosition(QTextCursor::End);

    if (questMetrics->valid() && cgalMetrics->valid() && recipie->valid())
    {
        ScatterData cgalScatter(*cgalMetrics, *questMetrics);
        CPPlotLvN cgalScatterPlot(cgalScatter
                                  , directory.absolutePath()
                                  , *recipie);
        //cgalScatterPlot.populateDocument();
        QTextDocumentFragment qvCFrag = cgalScatterPlot.contents();
        cursor.insertFragment(qvCFrag);
        cursor.movePosition(QTextCursor::End);
    }



    if (questMetrics->valid() && aleMetrics->valid() && recipie->valid())
    {

        QTextBlockFormat format = cursor.blockFormat();
        format.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysBefore);
        cursor.setBlockFormat(format);

        ScatterData cgalScatter(*aleMetrics, *questMetrics);
        CPPlotLvN cgalScatterPlot(cgalScatter
                                  , directory.absolutePath()
                                  , *recipie);
        QTextDocumentFragment qvAFrame = cgalScatterPlot.contents();
        cursor.insertFragment(qvAFrame);
        cursor.movePosition(QTextCursor::End);
    }

    if (runTimes->valid())
    {
        //runTimes->populateDocument();
        QTextDocumentFragment timesFrame = runTimes->contents();
        cursor.insertFragment(timesFrame);

        QTextBlockFormat format = cursor.blockFormat();
        format.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysAfter);
        cursor.setBlockFormat(format);
    }



    cursor.movePosition(QTextCursor::End);
}

void StrainPipeData::header(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    QTextCharFormat headerCharF = block.charFormat();
    headerCharF.setFontPointSize(30);
    headerCharF.setFontWeight(QFont::Bold);
    cursor.setBlockCharFormat(headerCharF);

    QString header= directory.absoluteFilePath() + " results\n";
    QTextDocumentFragment headerFrag
            = QTextDocumentFragment::fromPlainText(header);
    cursor.insertFragment(headerFrag);
}
