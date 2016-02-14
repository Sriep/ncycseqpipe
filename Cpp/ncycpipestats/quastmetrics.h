#ifndef QUASTMETRICS_H
#define QUASTMETRICS_H
#include <QFileInfo>
#include <QMap>
#include <QList>
#include <QString>
#include "pipemetric.h"

/**
 * @brief Result of running Quast http://quast.bioinf.spbau.ru/manual.html
 * on an assembly.
 */
class QuastMetrics : public PipeMetric
{
public:
    /**
     * @brief Quast data associated with a single assembly or fasta file.
     */
    typedef QMap<QString, QString> QuastAssemblyData;
    /**
     * @brief Quast data from a list of assemblies in a ncycpipe result folder.
     */
    typedef QMap<QString, QuastAssemblyData> QuastFolderData;
    /**
     * @brief QuastMetrics
     * @param quastDataFile
     */
    QuastMetrics(QFileInfo quastDataFile);
    const QuastFolderData folderData();
private:
    void init();
    //QuastAssemblyData readQuastDataLine(QStringList header, QStringList data);

    QuastFolderData quastData;
    QFileInfo quastDataFile;
    const char seperator = '\t';
};

#endif // QUASTMETRICS_H
