#include "scatterdata.h"

ScatterData::ScatterData(CgalMetrics& cgal, QuastMetrics& quast)
{
    CgalMetrics::CgalFolderData cgalData=cgal.cgalData();
    QuastMetrics::QuastFolderData quastData=quast.folderData();
    CgalMetrics::CgalDataIterator c_iter(cgalData);
    while (c_iter.hasNext())
    {
        c_iter.next();
        if (quastData.contains(c_iter.key())
                && quastData.value(c_iter.key()).contains("N75"))
        {
            y.append(c_iter.value().totalLikelihoodValue);
            x.append(quastData.value(c_iter.key()).value("N75").toDouble());
            pointLabel.append(c_iter.key());
        }
    }
}
