#include <QTextStream>
#include <QStringList>
#include "cgalmetrics.h"

CgalMetrics::CgalMetrics(QFileInfo cgalDataFile)
    : cgalDataFile(cgalDataFile)
{
    init();
}

const CgalMetrics::CgalFolderData CgalMetrics::cgalData()
{
    return cgalFolderData;
}

void CgalMetrics::init()
{
    QFile cgalFile(cgalDataFile.absoluteFilePath());
    cgalFile.open(QIODevice::ReadOnly);
    QTextStream inText(&cgalFile);
    QString nextAssembly;
    while (!inText.atEnd())
    {
        QString line=inText.readLine();
        QStringList splitLine=line.split(seperator);
        if (1 == splitLine.size())
        {
            QString fileName=splitLine.at(0);
            QStringList splitFN=fileName.split('_');
            nextAssembly=splitFN.at(1);
        }
        else if (6 == splitLine.size())
        {
            CgalData data(splitLine.at(0).toInt()
                          ,splitLine.at(1).toDouble()
                          ,splitLine.at(2).toDouble()
                          ,splitLine.at(3).toDouble()
                          ,splitLine.at(4).toInt()
                          ,splitLine.at(5).toInt());
            cgalFolderData[nextAssembly]=data;
        }
        else
        {
            //Maybe throw exception!
        }
    }
    cgalFile.close();
}
