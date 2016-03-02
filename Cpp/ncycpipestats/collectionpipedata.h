#ifndef COLLECTIONPIPEDATA_H
#define COLLECTIONPIPEDATA_H
#include <QString>
#include <QVector>

#include "pipedata.h"
#include "strainpipedata.h"

class CollectionPipeData : public PipeData
{
public:
    CollectionPipeData(const QString& directory);

private:
    QVector<StrainPipeData> strainsData;
};

#endif // COLLECTIONPIPEDATA_H
