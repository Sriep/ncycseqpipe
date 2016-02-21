#-------------------------------------------------
#
# Project created by QtCreator 2016-02-21T15:02:29
#
#-------------------------------------------------

QT       += core printsupport
QT       += gui
QT       += widgets

TARGET = qcustomplot
TEMPLATE = lib

DEFINES += QCUSTOMPLOT_LIBRARY

SOURCES += qcustomplot.cpp \
    qcpdocumentobject.cpp

HEADERS += qcustomplot.h\
        qcustomplot_global.h \
    qcpdocumentobject.h

unix {
    target.path = /usr/lib
    INSTALLS += target
}
