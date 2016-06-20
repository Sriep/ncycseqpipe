#ifndef MAIN_H
#define MAIN_H

#include <QString>
#include <QtDebug>
#include <QVector>
#include <QCommandLineParser>
#include <QCommandLineOption>
#include <algorithm>
#include <string>

using namespace std;
static const string programName = "NcycPipeStats";
static const string version = "0.1.0.0";

void configCommandLineParser(QCommandLineParser& parser);
const QCommandLineOption pacbioBam(
            QStringList() << "p" << "pbbam"
            ,"PacBio bam file"
            ,"file"
            ,"");
const QCommandLineOption illuminaBam(
            QStringList() << "i" << "ibam"
            ,"Illumina bam file"
            ,"file"
            ,"");
const QCommandLineOption assemblyFasta(
            QStringList() << "a" << "assembly"
            ,"assembly"
            ,"file"
            ,"");
const QCommandLineOption repeatThreshold(
            QStringList() << "r" << "repeat_thresohold"
            ,"repeat thresohold"
            ,"int"
            ,"5");
const QCommandLineOption minRepeatSize(
            QStringList() << "s" << "min_size"
            ,"minimum repeat size"
            ,"int"
            ,"90");


void runProgram(QCommandLineParser& clp);
void runProgram2(QCommandLineParser& clp);
void processSingleDir(const QString& workDirectory, QCommandLineParser& clp);
void processMultipleDirs(const QString& workDirectory, QCommandLineParser& clp);

std::string removeChar( std::string str, char ch );
QVector<double> vectorInt2VectorDouble(const QVector<int> inV);


#endif // MAIN_H
