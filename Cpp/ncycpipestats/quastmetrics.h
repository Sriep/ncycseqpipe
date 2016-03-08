#ifndef QUASTMETRICS_H
#define QUASTMETRICS_H
#include <QFileInfo>
#include <QMap>
#include <QList>
#include <QString>


/**
 * @brief Result of running Quast http://quast.bioinf.spbau.ru/manual.html
 * on an assembly.
 */
class QuastMetrics
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
    typedef QMapIterator<QString, QString> QuastAssemblyDataIterator;
    typedef QMapIterator<QString, QuastAssemblyData> QuastFolderDataIterator;

    QuastMetrics() {};
    QuastMetrics(QFileInfo quastDataFile) ;
    QuastFolderData folderData() const;
    bool valid() const;
private:
    void init();
    void dump();
    //QuastAssemblyData readQuastDataLine(QStringList header, QStringList data);

    QuastFolderData quastData;
    QFileInfo quastDataFile;
    const char seperator = '\t';
};

#endif // QUASTMETRICS_H
