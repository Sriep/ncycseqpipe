#include <QDir>
#include <QFileInfoList>
#include <QTextDocumentFragment>
#include "qcpdocumentobject.h"
#include "strainpipedata.h"
#include "collectionpipedata.h"

CollectionPipeData::CollectionPipeData()
    :   QTextDocument(), directory()
{
}

CollectionPipeData::CollectionPipeData(const QFileInfo& directory)
    : QTextDocument(), directory(directory)
{
    if (directory.exists()) init();
}

CollectionPipeData::~CollectionPipeData()
{

}

void CollectionPipeData::init()
{
    QDir* base_dir = new QDir(directory.absoluteFilePath());
    QFileInfoList dirsInfo = base_dir->entryInfoList(QDir::Dirs);
    for (int i = 0; i < dirsInfo.size(); ++i)
    {
        QString fname = dirsInfo.at(i).baseName();
        if (validDataDir(fname))
        {
            StrainPipeData* nextStrain = new StrainPipeData(dirsInfo.at(i));
            if (nextStrain->valid())
            {
                strainsData.append(nextStrain);
            }
        }
    }

    // register the plot document object (only needed once, no matter how many
    // plots will be in the QTextDocument):
    QCPDocumentObject *plotObjectHandler = new QCPDocumentObject();
    QTextDocument::documentLayout()->
          registerHandler(QCPDocumentObject::PlotTextFormat, plotObjectHandler);

}

void CollectionPipeData::populate()
{    
    if (!valid()) return;
    header(firstBlock());

    QTextCursor cursor(this);
    cursor.movePosition(QTextCursor::End);
    for (int i = 0; i < strainsData.size(); ++i)
    {
        if (NULL != strainsData.at(i) && strainsData.at(i)->valid())
        {            
            QTextDocumentFragment frag = strainsData.at(i)->contents();
            cursor.insertFragment(frag);

            QTextBlockFormat format = cursor.blockFormat();
            format.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysBefore);
            cursor.setBlockFormat(format);

            cursor.movePosition(QTextCursor::End);
        }
    }
}

void CollectionPipeData::header(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    QTextCharFormat headerCharF = block.charFormat();
    headerCharF.setFontPointSize(30);
    headerCharF.setFontWeight(QFont::Bold);
    cursor.setBlockCharFormat(headerCharF);

    QString header= "collection results";
    QTextDocumentFragment headerFrag
            = QTextDocumentFragment::fromPlainText(header);
    cursor.insertFragment(headerFrag);
}

bool CollectionPipeData::validDataDir(const QFileInfo &finfo)
{
    QString name = finfo.baseName();
    return name != "" && name != "pipline_parameters";
}

void CollectionPipeData::writeToPdf()
{
    if (!valid()) return;
    if (isEmpty()) populate();
    QString pdfFilename = directory.absoluteFilePath() + "/CollectionData" + ".pdf";
    QPdfWriter* pdfWriter = new QPdfWriter(pdfFilename);
    pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setTitle("Collection Directory iformation");
    print(pdfWriter);
}

bool CollectionPipeData::valid() const
{
    return strainsData.size() > 0;
}
