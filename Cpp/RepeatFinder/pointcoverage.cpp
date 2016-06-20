#include <api/BamReader.h>
#include <api/BamAlignment.h>
#include <stdexcept>
#include <QDebug>
#include "pointcoverage.h"

using namespace BamTools;

PointCoverage::PointCoverage(const string &fastafile, const string &bamfile)
    : FastaData<int>(fastafile), bamfile(bamfile), fastafile(fastafile)
{
    init();
  }

long long  PointCoverage::getLargestCoverage() const
{
    return largestCoverage;
}

long long PointCoverage::getTotalCoverage() const
{
    return totalCoverage;
}

long long  PointCoverage::getMappedReads() const
{
    return mappedReads;
}

void PointCoverage::init()
{
   BamReader bamReader;
   if (!bamReader.Open(bamfile))
      throw runtime_error("Can't open bam file");
   bamReader.Rewind();
   const RefVector& refData = bamReader.GetReferenceData();
   BamAlignment bamAl;
   while(bamReader.GetNextAlignment(bamAl))
   {
       if (0 <= bamAl.Position)
       {
           unsigned int lastPos = bamAl.Position + bamAl.Length;
           string refName = refData[bamAl.RefID].RefName;
           if (find(refName) == end())
               throw runtime_error("Cannot find read");
           vector<int>& contig = at(refName);
           if (contig.size() >= lastPos)
           {
               for ( unsigned int i = bamAl.Position ; i < lastPos ; i++ )
               {
                   contig[i] = contig[i] +1;
                   if (contig[i] > largestCoverage)
                   {
                       largestCoverage = contig[i];
                       contigWithLargestCoverage = refName;
                       positionLargestCoverage = i;
                   }
               }
               totalCoverage += bamAl.Length;
               mappedReads++;
           }
           else
           {
               qDebug() << "Read too long for contig";
                       // << "/tcontig name: " << bamAl.Name
                       // << "/tread start: " <<  bamAl.Position
                       // << "/tread length: " << bamAl.Length;
               nonFitttingReads++;
               //throw runtime_error("Read too long for contig");
           }
       }
       else
       {
           unmappedReads++;
       }

   }
   //vector<int>& highCovCont = at(contigWithLargestCoverage);
   //qDebug() << "contigWithLargestCoverage";
}

string PointCoverage::getFastafile() const
{
    return fastafile;
}

long PointCoverage::getNonFitttingReads() const
{
    return nonFitttingReads;
}

long PointCoverage::getUnmappedReads() const
{
    return unmappedReads;
}

string PointCoverage::getBamfile() const
{
    return bamfile;
}
