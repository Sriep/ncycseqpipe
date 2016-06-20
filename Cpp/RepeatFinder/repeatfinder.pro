#-------------------------------------------------
#
# Project created by QtCreator 2014-06-28T22:14:45
#
#-------------------------------------------------

QT       += core printsupport
QT       += gui
QT       += widgets
#QT += charts


TARGET = repeatfinder
CONFIG  += c++11

TEMPLATE = app

LIBS += -L../../bamtools/lib -lbamtools
DEPENDPATH += ../../bamtools/include
INCLUDEPATH += ../../bamtools/include

SOURCES += \
    main.cpp \
    options.cpp \
    fastadata.cpp \
    pointcoverage.cpp \
    qcustomplot.cpp \
    qcpdocumentobject.cpp \
    bamfastastats.cpp \
    coveragesfound.cpp \
    variablerepeat.cpp \
    repeats.cpp \
    fassembly.cpp \
    viewrepeats.cpp

HEADERS += \
    main.h \
    options.h \
    fastadata.h \
    pointcoverage.h \
    qcustomplot.h \
    qcpdocumentobject.h \
    bamfastastats.h \
    coveragesfound.h \
    variablerepeat.h \
    repeats.h \
    fassembly.h \
    viewrepeats.h

