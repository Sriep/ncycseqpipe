#ifndef COLLECTIONPIPEDATA_H
#define COLLECTIONPIPEDATA_H
#include <QString>
#include <QVector>

#include <memory>
#include "strainpipedata.h"

class CollectionPipeData : public  QTextDocument
{
public:
    CollectionPipeData();
    CollectionPipeData(const QFileInfo &directory);
    virtual ~CollectionPipeData();
    void writeToPdf();
    bool valid() const;
private:
    void init();
    void populate();
    void header(QTextBlock block);
    static bool validDataDir(const QFileInfo& finfo);
    QVector<StrainPipeData*> strainsData;
    //QVector<std::unique_ptr<StrainPipeData>> strainsData;
    QFileInfo directory;
};

#endif // COLLECTIONPIPEDATA_H
