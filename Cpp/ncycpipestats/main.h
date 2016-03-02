#ifndef MAIN_H
#define MAIN_H

#include <QString>
#include <QtDebug>
#include <QCommandLineParser>
#include <QCommandLineOption>

using namespace std;
static const string programName = "NcycPipeStats";
static const string version = "0.1.0.0";

void configCommandLineParser(QCommandLineParser& parser);
const QCommandLineOption singleDir(
            QStringList() << "s" << "strain"
            ,"Data directroy: Internal output directory from ncycseqpipe"
            "for a single strain."
            ,"direcotry"
            ,"");
const QCommandLineOption multipleDirs(
            QStringList() << "m" << "mulistrain"
            ,"Data directroy: Top level output directory from ncycseqpipe"
            "conatining multipe strains strain."
            ,"direcotry"
            ,"");


void runProgram(QString workDirectory);
void processSingleDir(const QString& workDirectory, QCommandLineParser& clp);
void processMultipleDirs(const QString& workDirectory, QCommandLineParser& clp);

#endif // MAIN_H
