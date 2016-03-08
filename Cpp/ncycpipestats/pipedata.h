#ifndef PIPEMETRIC_H
#define PIPEMETRIC_H
#include <QString>
#include "recipielist.h"

/**
 * @brief Base class for metrics produced in pipline
 */
class PipeData
{
public:
    PipeData();

protected:
    virtual QString assembly(QString filename);    
};

#endif // PIPEMETRIC_H
