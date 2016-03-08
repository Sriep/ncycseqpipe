#ifndef RECIPIELIST_H
#define RECIPIELIST_H
#include <QFileInfo>
#include <QVector>
#include "pipedata.h"

class RecipieList
{
public:
    RecipieList() {}
    RecipieList(const QFileInfo &recipieFile);

    struct Recipie
    {
        QString instructionType;
        QString name;
        QString location;
        QString tag;
        QString parameters;
        Recipie() {}
        Recipie(const QString& s1
                , const QString& s2=""
                , const QString& s3=""
                , const QString& s4=""
                , const QString& s5="")
            : instructionType(s1)
            ,name(s2)
            ,location(s3)
            ,tag(s4)
            ,parameters(s5)
        {}
    };

    QVector<Recipie> recipiesData() const;
    bool valid() const;
private:
    void init();

    QFileInfo recipieFile;
    QVector<Recipie> recipies;
    const char seperator=',';
};

#endif // RECIPIELIST_H
