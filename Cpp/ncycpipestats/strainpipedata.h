#ifndef STRAINPIPEDATA_H
#define STRAINPIPEDATA_H
#include <QFileInfo>
#include <QDir>
#include <QTextDocument>
#include <QTextDocumentFragment>
#include <QTextBlock>
#include <memory>
#include "cgalmetrics.h"
#include "alemetrics.h"
#include "runtimes.h"
#include "recipielist.h"
#include "quastmetrics.h"

class StrainPipeData  : public QTextDocument
{
public:
    StrainPipeData(const QFileInfo& directory);
    StrainPipeData();
    virtual ~StrainPipeData();
    bool valid() const;
    void writeToPdf();
    QTextDocumentFragment contents();
private:
    void init();
    void populate();
    void header(QTextBlock block);

    QFileInfo directory;
    QDir base_dir;

    std::unique_ptr<RecipieList> recipie;
    std::unique_ptr<QuastMetrics> questMetrics;
    std::unique_ptr<CgalMetrics> cgalMetrics;
    std::unique_ptr<AleMetrics> aleMetrics;
    std::unique_ptr<RunTimes> runTimes;
};

#endif // STRAINPIPEDATA_H
