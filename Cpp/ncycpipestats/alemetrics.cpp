#include <QTextStream>
#include "alemetrics.h"

AleMetrics::AleMetrics(QFileInfo aleDataFile)
    : aleDataFile(aleDataFile)
{
    init();
}

const QMap<QString, double> AleMetrics::aleData() const
{
    return aleFolderData;
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
