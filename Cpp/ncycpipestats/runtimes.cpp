#include <QTextStream>
#include <QStringList>
#include <QFile>
#include <QTextBlock>
#include <QTextCharFormat>
#include <QPdfWriter>
#include <QTextDocumentFragment>
#include <ctime>
#include "runtimes.h"

RunTimes::RunTimes()
    : timesLogFile()
{

}

RunTimes::RunTimes(const QFileInfo& timesLogFile
                   , const QString& strain
                   , const QString& workdir)
    : document()
    , timesLogFile(timesLogFile)
    , strain(strain)
    , workdir(workdir)
{
    if (timesLogFile.exists()) init();
}

void RunTimes::init()
{
    QFile file(timesLogFile.absoluteFilePath());
    file.open(QIODevice::ReadOnly);
    QTextStream inText(&file);
    while (!inText.atEnd())
    {
        QString line=inText.readLine();
        line = line.replace(' ', '\t');
        QStringList splitLine=line.split('\t', QString::SkipEmptyParts);
        if (10 == splitLine.size())
        {
            QString a = splitLine.at(3);
            QStringList base=a.split('/',QString::SkipEmptyParts);
            if (base.size() > 0)
            {
                RunTimeData data(splitLine.at(1)
                             ,base.last()
                             ,splitLine.at(5)
                             ,splitLine.at(7)
                             ,splitLine.at(9));
                timingsData.append(data);
            }
        }
        else
        {
            //Maybe throw exception!
        }
    }
    file.close();
}

void RunTimes::populateDocument()
{
    setHeader(document.firstBlock());
    QTextCursor cursor(&document);
    cursor.movePosition(QTextCursor::End);
    setData(cursor);
}

void RunTimes::setHeader(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    QTextCharFormat headerCharF = block.charFormat();
    headerCharF.setFontPointSize(25);
    headerCharF.setFontWeight(QFont::Bold);
    cursor.setBlockCharFormat(headerCharF);

    QString header = "Straing" + strain + "Timeings for tools run in pipeline";
    QTextDocumentFragment headerFrag
            = QTextDocumentFragment::fromPlainText(header);
    cursor.insertFragment(headerFrag);

}

void RunTimes::setData(QTextCursor cursor)
{
    cursor.insertTable(timingsData.size()+1 ,5);
    cursor.insertText("Tool");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Assembler");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Start");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Finish");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Taken hours");
    cursor.movePosition(QTextCursor::NextCell);
    for ( int i=0 ; i < timingsData.size() ; i++ )
    {
        cursor.insertText(timingsData.at(i).tool);
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(timingsData.at(i).assembly);
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(dateFromEpch(timingsData.at(i).start));
        //cursor.insertText(QString::number(timingsData.at(i).start));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(dateFromEpch(timingsData.at(i).finish));
        cursor.movePosition(QTextCursor::NextCell);
        double hours = timingsData.at(i).taken;
        hours = hours / (60 * 60);
        cursor.insertText(QString::number(hours));
        cursor.movePosition(QTextCursor::NextCell);
    }
}

QString RunTimes::dateFromEpch(int seconds)
{
    time_t t = time(NULL);
    t = seconds;
    struct tm *tm = localtime(&t);
    char date[30];
    strftime(date, sizeof(date), "%c", tm);
    return QString(date);
}

QVector<RunTimes::RunTimeData> RunTimes::getTimingsData() const
{
    return timingsData;
}

void RunTimes::writeToPdf()
{
    if (document.isEmpty()) populateDocument();
    QString pdfFilename = workdir + "/" + strain + "_Timings.pdf";
    QPdfWriter* pdfWriter = new QPdfWriter(pdfFilename);
    pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setTitle(strain + "Timeings for tools run in pipeline");
    document.print(pdfWriter);
}

bool RunTimes::valid() const
{
    return timesLogFile.exists();
}

QTextFrame* RunTimes::getTextFrame()
{
    if (document.isEmpty()) populateDocument();
    return document.rootFrame();
}

QTextDocumentFragment RunTimes::contents()
{
    if (document.isEmpty()) populateDocument();
    QTextCursor cursor(&document);
    cursor.movePosition(QTextCursor::Start, QTextCursor::MoveAnchor);
    cursor.movePosition(QTextCursor::End, QTextCursor::KeepAnchor);
    return cursor.selection();
}


