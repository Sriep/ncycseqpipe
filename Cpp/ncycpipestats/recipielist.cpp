#include <QTextStream>
#include <QStringList>
#include "recipielist.h"

RecipieList::RecipieList(const QFileInfo& recipieFile)
 : recipieFile(recipieFile)
{
    if (recipieFile.exists()) init();
}

QVector<RecipieList::Recipie> RecipieList::recipiesData() const
{
    return recipies;
}

bool RecipieList::valid() const
{
    return recipieFile.exists();
}

void RecipieList::init()
{
    QFile file(recipieFile.absoluteFilePath());
    file.open(QIODevice::ReadOnly);
    QTextStream inText(&file);
    while (!inText.atEnd())
    {
        QString line=inText.readLine();
        if (line.at(0) != '#')
        {
            QStringList splitLine=line.split(seperator);
            if (1 == splitLine.size())
            {
                Recipie data(splitLine.at(0));
                recipies.append(data);
            }
            else if (5 == splitLine.size())
            {
                Recipie data(splitLine.at(0)
                             ,splitLine.at(1)
                             ,splitLine.at(2)
                             ,splitLine.at(3)
                             ,splitLine.at(4));
                recipies.append(data);
            }
            else
            {
                //Maybe throw exception!
            }
        }
    }
    file.close();
}
