#include <QCoreApplication>
#include <QSettings>
#include <QDir>
#include <QFileInfo>
#include <QtDebug>
#include <QStringList>
#include <QTextDocumentWriter>
#include <QtWidgets/QApplication>

#include "main.h"
#include "quastmetrics.h"
#include "cgalmetrics.h"
#include "alemetrics.h"
#include "scatterdata.h"
#include "cpplotlvn.h"
#include "recipielist.h"
#include "runtimes.h"
#include "strainpipedata.h"
#include "collectionpipedata.h"

//#include <QtCharts/QtCharts>
//using namespace QtCharts;


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QApplication::setOrganizationName("NCYC");
    QApplication::setApplicationName("NcycPipeStats");
    QCommandLineParser clp;
    configCommandLineParser(clp);
    clp.process(a);
    //QString workDirectory(argv[1]);
    //runProgram(workDirectory);
    if (clp.value(singleDir).size()>0)
    {
        QString workDirectory = clp.value(singleDir);
        processSingleDir(workDirectory, clp);
    }
    if (clp.value(multipleDirs).size()> 0)
    {
        QString workDirectory = clp.value(multipleDirs);
        processMultipleDirs(workDirectory, clp);
    }

    return 0;//a.exec();
}

void processMultipleDirs(const QString& workDirectory, QCommandLineParser& clp)
{


    // QString workDirectory = clp.value(multipleDirs);
    /*QDir* base_dir = new QDir(workDirectory);
    QFileInfoList dirsInfo = base_dir->entryInfoList(QDir::Dirs);
    for (int i = 0; i < dirsInfo.size(); ++i)
    {
        if (dirsInfo.at(i).baseName().left(4) == "NCYC")
        {
            //QString dirName=dirs.at(i).absoluteFilePath;
            processSingleDir(dirsInfo.at(i).absoluteFilePath(), clp);
        }
    }*/
    QFileInfo wdfi(workDirectory);
    CollectionPipeData collection(wdfi);
    collection.writeToPdf();

    QTextDocumentWriter writer;
    writer.setFormat("HTML");
    writer.setFileName(workDirectory + "collection.html");
    writer.write(&collection);

    writer.setFormat("plaintext");
    writer.setFileName(workDirectory + "collection.txt");
    writer.write(&collection);

    writer.setFormat("ODF");
    writer.setFileName(workDirectory + "collection.odf");
    writer.write(&collection);


}

void processSingleDir(const QString& workDirectory, QCommandLineParser& clp)
{
    QDir* base_dir = new QDir(workDirectory);
    QString strain=base_dir->dirName();

    QFileInfo wdinfo(workDirectory);
    StrainPipeData strainData(wdinfo);
    if (strainData.valid()) strainData.writeToPdf();
    return;
/*
    QFileInfo recipiefileinfo(workDirectory + "/logdir/1.RECIPEFILE");
    RecipieList recipieStuff(recipiefileinfo);

    base_dir->setNameFilters(QStringList("metric_*quast.csv"));
    QFileInfoList quastMetrics=base_dir->entryInfoList();

    if (!quastMetrics.empty() && recipiefileinfo.exists())
    {
        QuastMetrics quastStuff(quastMetrics.at(0));

        base_dir->setNameFilters(QStringList("metric_*cgal.csv"));
        QFileInfoList cgalMetrics=base_dir->entryInfoList();
        if (!cgalMetrics.empty())
        {
            CgalMetrics cgalStuff(cgalMetrics.at(0));
            ScatterData cgalScatter(cgalStuff, quastStuff);
            CPPlotLvN cgalScatterPlot(cgalScatter, workDirectory, recipieStuff);
            cgalScatterPlot.writeToPdf();
        }

        base_dir->setNameFilters(QStringList("metric_*ale.csv"));
        QFileInfoList aleMetrics=base_dir->entryInfoList();
        if (!aleMetrics.empty())
        {
            AleMetrics aleStuff(aleMetrics.at(0));
            ScatterData aleScatter(aleStuff, quastStuff);
            CPPlotLvN aleScatterPlot(aleScatter, workDirectory, recipieStuff);
            aleScatterPlot.writeToPdf();
        }


        QString timesFilename = base_dir->absolutePath()
                + "/logdir/1stats/allstats.csv";
        QFileInfo timesFileInfo(timesFilename);
        if (timesFileInfo.exists())
        {
            RunTimes runTimes(timesFileInfo, strain, workDirectory);
            runTimes.writeToPdf();
        }
    }*/
}

void configCommandLineParser(QCommandLineParser& clp)
{
    clp.setApplicationDescription("Creates statistics files from ncycseqpipe output");
    clp.addHelpOption();
    clp.addVersionOption();
    clp.addOption(singleDir);
    clp.addOption(multipleDirs);
}
