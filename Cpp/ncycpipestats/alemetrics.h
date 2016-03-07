#ifndef ALEMETRICS_H
#define ALEMETRICS_H
#include <QString>
#include <QMap>
#include <QFileInfo>
#include "pipedata.h"

class AleMetrics : public PipeData
{
public:
    AleMetrics();
    AleMetrics(QFileInfo aleDataFile);
    const QMap<QString, double> aleData() const;

    bool valid() const;
private:
    void init();

    QMap<QString, double>  aleFolderData;
    QFileInfo aleDataFile;

    const QString leftText = "# ALE_score: ";
};

#endif // ALEMETRICS_H
