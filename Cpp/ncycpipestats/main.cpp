#include <QCoreApplication>
#include <QSettings>
#include <QDir>
#include <QFileInfo>
#include <QStringList>

#include <QtWidgets/QApplication>
#include <QtWidgets/QMainWindow>
//#include "chartview.h"

#include "main.h"
#include "options.h"
#include "quastmetrics.h"
#include "cgalmetrics.h"
#include "scatterdata.h"
#include "plotlvn.h"

int main(int argc, char *argv[])
{

    QApplication a(argc, argv);
    //QCoreApplication a(argc, argv);
    QString workDirectory(argv[1]);
    runProgram(workDirectory);
    return a.exec();

    /*try
    {
        try
        {
            Options::readOptions(argc, argv);
            QString workDirectory(argv[1]);
            runProgram(workDirectory);

        }
        catch (const exception& ex)
        {
            perror(ex.what());
            return errno;
        }
    }
    catch (...)
    {
        perror("");
        return errno;
    }*/
}

void runProgram(QString workDirectory)
{
    //QCoreApplication::setOrganizationName("NCYC");
    //QCoreApplication::setApplicationName("NcycPipeStats");

    QSettings settings("ncyc", "ncycpipe");
    QDir* base_dir = new QDir(workDirectory);

    QStringList cgalFilter;
    cgalFilter << "metric_*cgal.csv";
    base_dir->setNameFilters(cgalFilter);
    QFileInfoList metrics=base_dir->entryInfoList();//metricFilter, QDir::Files, QDir::Name);
    CgalMetrics cgalStuff(metrics.at(0));

    //CgalMetrics::CgalFolderData cgalData=cgalStuff.cgalData();

    QStringList quastFilter;
    quastFilter << "metric_*quast.csv";
    base_dir->setNameFilters(quastFilter);
    metrics=base_dir->entryInfoList();//metricFilter, QDir::Files, QDir::Name);
    QuastMetrics quastStuff(metrics.at(0));

    //QuastMetrics::QuastFolderData quastData=quastStuff.folderData();
    //ScatterData(CgalMetrics& cgal, QuastMetrics& quast);
    ScatterData scatterData(cgalStuff, quastStuff);
    PlotLvN scatterPlot(scatterData, workDirectory);
    //scatterPlot.show();
}



































