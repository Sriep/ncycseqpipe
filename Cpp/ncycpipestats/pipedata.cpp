#include "pipedata.h"
#include <QStringList>

PipeData::PipeData()
{

}

QString PipeData::assembly(QString filename)
{
    QStringList splitFilename=filename.split(QRegExp("[\\/]"));
    QString basename=splitFilename.last();
    QStringList baseSplit=basename.split("_");
    QString assembly;
    if (2 < baseSplit.size())
    {
        assembly=baseSplit.at(1);
    }
    return assembly;
}
