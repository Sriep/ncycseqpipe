#include <QTextStream>
#include "alemetrics.h"

AleMetrics::AleMetrics()
    :aleDataFile()
{

}

AleMetrics::AleMetrics(QFileInfo aleDataFile)
    : aleDataFile(aleDataFile)
{
    if (aleDataFile.exists()) init();
}

const QMap<QString, double> AleMetrics::aleData() const
{
    return aleFolderData;
}

bool AleMetrics::valid() const
{
    return aleDataFile.exists();
}

void AleMetrics::init()
{
    QFile aleFile(aleDataFile.absoluteFilePath());
    aleFile.open(QIODevice::ReadOnly);
    QTextStream inText(&aleFile);
    QString nextAssembly;
    while (!inText.atEnd())
    {
        QString line=inText.readLine();
        if (line.left(leftText.size()) == leftText)
        {
            int rightFrag = line.size()-leftText.size();
            double aleScore = line.right(rightFrag).toDouble();
            aleFolderData[nextAssembly]=aleScore;
        }
        else
        {
            nextAssembly=assembly(line);
        }
    }
    aleFile.close();
}
