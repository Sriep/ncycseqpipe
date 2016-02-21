#include <QTextStream>
#include <QStringList>
#include <QtDebug>
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
    dump();
}

void QuastMetrics::dump()
{
    qDebug() << "dumping quast metrics";
    QuastFolderDataIterator i(quastData);
    while (i.hasNext()) {
        i.next();
        qDebug() << i.key() << i.value() << "N75=" << i.value().value("N75");
        //QuastAssemblyDataIterator j(i.value());
        //while (j.hasNext())
        //{
        //    j.next();
        //    qDebug() << j.key() << j.value();
        //    //cout << j.key() << ": " << j.value() << endl;
        //}
    }
    qDebug() << "finished dumping quast metircs";
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
