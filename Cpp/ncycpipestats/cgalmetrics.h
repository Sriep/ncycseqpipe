#ifndef CGALMETRICS_H
#define CGALMETRICS_H
#include <QFileInfo>
#include <QMap>
#include "pipemetric.h"

/**
 * @brief The CgalMetrics class
 */
class CgalMetrics : public PipeMetric
{
public:
    /**
     * @brief CgalMetrics
     * @param cgalDataFile
     */
    CgalMetrics(QFileInfo cgalDataFile);

    /**
     * @brief The CGAL ouput ﬁle contains following values
     */
    struct CgalData
    {
        /// @brief Number of contigs
        int numberOfContigs;
        /// @brief Total likelihood value
        double totalLikelihoodValue;
        /// \brief Likelihood value of reads mapped by the mapping tool
        double mappedReadsLikelihood;
        /// \brief Likelihood value corresponding to reads not mapped
        double notMappedReadsLikelihhod;
        /// \brief  Total number of paired-end reads
        int numberPairedEndReads;
        /// \brief Number of reads not mapped by the mapper
        int readsNotMapped;
        CgalData() {}
        ///
        /// \brief CgalData
        /// \param i1
        /// \param d1
        /// \param d2
        /// \param d3
        /// \param i2
        /// \param i3
        ///
        CgalData(int i1, double d1, double d2, double d3, int i2, int i3)
            : numberOfContigs(i1)
            ,totalLikelihoodValue(d1)
            ,mappedReadsLikelihood(d2)
            ,notMappedReadsLikelihhod(d3)
            ,numberPairedEndReads(i2)
            ,readsNotMapped(i3)
        {}
    };

    /**
     * @brief CgalFolderData
     */
    typedef QMap<QString, CgalData> CgalFolderData;
    typedef QMapIterator<QString, CgalData> CgalDataIterator;
    const CgalFolderData cgalData();
private:
    void init();

    CgalFolderData cgalFolderData;
    QFileInfo cgalDataFile;
    const char seperator = '\t';
};

#endif // CGALMETRICS_H
