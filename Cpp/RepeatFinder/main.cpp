#include <QCoreApplication>
#include <QtDebug>
#include <QtWidgets/QApplication>

#include "main.h"
#include "fastadata.h"
#include "pointcoverage.h"
#include "bamfastastats.h"
#include "coveragesfound.h"
#include "repeats.h"
#include "viewrepeats.h"
#include "fassembly.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QApplication::setOrganizationName("NCYC");
    QApplication::setApplicationName("RepeatFinder");
    QCommandLineParser clp;
    configCommandLineParser(clp);
    clp.process(a);
    if (clp.value(assemblyFasta).size()>0)
    {
        runProgram2(clp);
    }
    return 0;//a.exec();
}

void configCommandLineParser(QCommandLineParser& clp)
{
    clp.setApplicationDescription("Count stuff");
    clp.addHelpOption();
    clp.addVersionOption();
    clp.addOption(pacbioBam);
    clp.addOption(illuminaBam);
    clp.addOption(assemblyFasta);
    clp.addOption(repeatThreshold);
    clp.addOption(minRepeatSize);
}

void runProgram(QCommandLineParser &clp)
{
    FAssembly fa(clp.value(assemblyFasta).toStdString());
    //PointCoverage pc(clp.value(assemblyFasta).toStdString()
    //                 ,clp.value(pacbioBam).toStdString());
    std::shared_ptr<PointCoverage>
            pc (new PointCoverage(clp.value(assemblyFasta).toStdString()
                                   ,clp.value(pacbioBam).toStdString()));
    CoveragesFound cf(pc);
    //Repeats repeats(pc, 3);
    int rThreshold = clp.value(repeatThreshold).toInt();
    int minSize = clp.value(minRepeatSize).toInt();
    std::shared_ptr<Repeats> repeats(new Repeats(pc, rThreshold, minSize));

    ViewRepeats viewRepeats(repeats);
    QString pdfname (clp.value(pacbioBam) + ".pdf");
    viewRepeats.wtireToPdf(QString(pdfname));
    QString repeatFN = clp.value(pacbioBam) + "_repeats.fasta";
    viewRepeats.writeRepeats(repeatFN);
}

void runProgram2(QCommandLineParser &clp)
{
    int rThreshold = clp.value(repeatThreshold).toInt();
    int minSize = clp.value(minRepeatSize).toInt();
    string assembly = clp.value(assemblyFasta).toStdString();
    string pbBam = clp.value(pacbioBam).toStdString();
    string ilBam = clp.value(illuminaBam).toStdString();

    std::shared_ptr<PointCoverage> pcPacBio (new PointCoverage(assembly, pbBam));
    std::shared_ptr<PointCoverage> pcIllumina (new PointCoverage(assembly, ilBam));

    std::shared_ptr<Repeats> rPB(new Repeats(pcPacBio, rThreshold, minSize));
    std::shared_ptr<Repeats> rIll(new Repeats(pcIllumina, rThreshold, minSize));
    std::shared_ptr<Repeats> rIntersect(new Repeats(*rPB, *rIll));

    ViewRepeats viewIntersect(rIntersect);
    QString pdfname (clp.value(pacbioBam) + "Intersect.pdf");
    viewIntersect.wtireToPdf(QString(pdfname));
    QString repeatFN = clp.value(pacbioBam) + "_Intersect_repeats.fasta";
    viewIntersect.writeRepeats(repeatFN);

    ViewRepeats viewIllumina(rIll);
    pdfname = (clp.value(illuminaBam) + ".pdf");
    viewIllumina.wtireToPdf(QString(pdfname));
    repeatFN = clp.value(illuminaBam) + "_repeats.fasta";
    viewIllumina.writeRepeats(repeatFN);

    ViewRepeats viewPacBio(rPB);
    pdfname = (clp.value(pacbioBam) + ".pdf");
    viewPacBio.wtireToPdf(QString(pdfname));
    repeatFN = clp.value(pacbioBam) + "_repeats.fasta";
    viewPacBio.writeRepeats(repeatFN);
}

std::string removeChar( std::string str, char ch )
{
    // remove all occurrences of char ch from str
    str.erase( std::remove( str.begin(), str.end(), ch ), str.end() ) ;
    return str ;
}

QVector<double> vectorInt2VectorDouble(const QVector<int> inV)
{
    QVector<double> rvl(inV.size());
    for ( int i ; i < inV.size() ; i++  )
    {
        rvl[i] = (double) inV[i];
    }
    return rvl;
}
