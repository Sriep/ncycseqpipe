#include <QTextStream>
#include <QStringList>
#include "quastmetrics.h"

QuastMetrics::QuastMetrics(QFileInfo quastDataFile)
    : quastDataFile(quastDataFile)
{
    init();
}

void QuastMetrics::init()
{
    QFile quastFile(quastDataFile.absoluteFilePath());
    quastFile.open(QIODevice::ReadOnly);
    QTextStream inText(&quastFile);
    QStringList headerLine;
    while (!inText.atEnd())
    {
        QString line=inText.readLine();
        QStringList splitLine=line.split(seperator);
        if (1 < splitLine.size())
        {
            if (splitLine.first() == "Assembly")
            {
                headerLine = splitLine;
            }
            else if (!headerLine.isEmpty())
            {
                QuastAssemblyData lineDataMap;
                for ( int i = 1 ; i < headerLine.size() ; i++ )
                {
                    if (i < splitLine.size())
                    {
                        lineDataMap[headerLine.at(i)]=splitLine.at(i);
                    }
                }
                quastData[splitLine.at(0)]=lineDataMap;
            }
        }
    }
    quastFile.close();
}

const QuastMetrics::QuastFolderData QuastMetrics::folderData()
{
    return quastData;
}

/*
QuastMetrics::QuastAssemblyData QuastMetrics::readQuastDataLine(QStringList header, QStringList data)
{
    QuastMetrics::QuastAssemblyData d;
    return d;
}*/
