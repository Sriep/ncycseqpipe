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
#include "recipielist.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    //QCoreApplication a(argc, argv);
    //QCoreApplication::setOrganizationName("NCYC");
    //QCoreApplication::setApplicationName("NcycPipeStats");
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
    QSettings settings("ncyc", "ncycpipe");
    QDir* base_dir = new QDir(workDirectory);

    QStringList cgalFilter;
    cgalFilter << "metric_*cgal.csv";
    base_dir->setNameFilters(cgalFilter);
    QFileInfoList metrics=base_dir->entryInfoList();
    CgalMetrics cgalStuff(metrics.at(0));

    QStringList quastFilter;
    quastFilter << "metric_*quast.csv";
    base_dir->setNameFilters(quastFilter);
    metrics=base_dir->entryInfoList();
    QuastMetrics quastStuff(metrics.at(0));

    QFileInfo recipiefileinfo(workDirectory + "/logdir/1.RECIPEFILE");
    RecipieList recipieStuff(recipiefileinfo);

    ScatterData scatterData(cgalStuff, quastStuff);
    PlotLvN scatterPlot(scatterData, workDirectory, recipieStuff);
    scatterPlot.writeToPdf();
}




































