#ifndef RUNTIMES_H
#define RUNTIMES_H
#include <QVector>
#include <QString>
#include <QFileInfo>
#include <QTextDocument>
#include <QTextCursor>

#include "pipedata.h"


class RunTimes : public PipeData
{
public:
    RunTimes();
    RunTimes(const QFileInfo& timesLogFile
             , const QString& strain
             , const QString &workdir);

    struct RunTimeData
    {
        QString tool;
        QString assembly;
        int start;
        int finish;
        int taken;
        RunTimeData() {}
        RunTimeData(const QString& tool
                 , const QString& assembly
                 , const QString& s
                 , const QString& f
                 , const QString& t)
            : tool(tool), assembly(assembly)
            ,start(s.toInt()), finish(f.toInt()), taken(t.toInt())
        {}
    };
    QVector<RunTimeData> getTimingsData() const;
    void writeToPdf();
    bool valid() const;
    QTextFrame* getTextFrame();
    QTextDocumentFragment  contents();

private:
    void init();

    void populateDocument();
    void setHeader(QTextBlock block);
    void setData(QTextCursor cursor);
    static QString dateFromEpch(int seconds);

    const QString strain;
    const QString workdir;
    QTextDocument document;
    QFileInfo timesLogFile;
    QVector<RunTimeData> timingsData;
};

#endif // RUNTIMES_H
