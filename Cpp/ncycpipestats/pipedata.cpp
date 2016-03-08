#include "pipedata.h"
#include <QStringList>

PipeData::PipeData()
{

}

QString PipeData::assembly(QString filename)
{
    QStringList splitFilename=filename.split(QRegExp("[\\/]"));
    QString basename=splitFilename.last();
    QStringList baseSplit=basename.split("_", QString::SkipEmptyParts);
    QString assembly;
    if (3 == baseSplit.size())
    {
        assembly=baseSplit.at(1);
    }
    else if (4 == baseSplit.size())
    {
        assembly=baseSplit.at(1) + "_" + baseSplit.at(2);
    }
    return assembly;
}
