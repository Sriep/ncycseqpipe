#ifndef RECIPIELIST_H
#define RECIPIELIST_H
#include <QFileInfo>
#include <QVector>
#include "pipedata.h"

class RecipieList : public PipeData
{
public:
    RecipieList() {}
    RecipieList(QFileInfo recipieFile);

    struct Recipie
    {
        QString instructionType;
        QString name;
        QString location;
        QString tag;
        QString parameters;
        Recipie() {}
        Recipie(QString s1, QString s2="", QString s3="", QString s4="", QString s5="")
            : instructionType(s1)
            ,name(s2)
            ,location(s3)
            ,tag(s4)
            ,parameters(s5)
        {}
    };

    QVector<Recipie> recipiesData() const;
private:
    void init();

    QFileInfo recipieFile;
    QVector<Recipie> recipies;
    const char seperator=',';
};

#endif // RECIPIELIST_H
