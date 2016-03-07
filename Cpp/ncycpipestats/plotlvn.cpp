#include <QPdfWriter>
#include <QMargins>
#include <QTextCursor>
#include <QTextDocumentFragment>
#include <QTextBlockFormat>
#include <QTextDocument>
#include <QFont>
#include <QPen>
#include <QString>
#include <QChar>
#include <QPageSize>
#include <QtDebug>
#include <algorithm>

#include "plotlvn.h"

PlotLvN::PlotLvN(ScatterData &scatterData, QString workDir, RecipieList &recipie)
    : scatterData(scatterData)
    , workDir(workDir)
    , recipieList(recipie)
{
    width = 800;
    height = 600;
    init();
}

PlotLvN::~PlotLvN()
{
}

void PlotLvN::init()
{

}

void PlotLvN::populateDocument()
{    


    //TESTTESTSETS
    // //http://doc.qt.io/qt-5/richtext-html-subset.html
    //QString test = "<a name=\"test\"> Test link </a>";
    //cursor.insertHtml(test);
    //headerFrag = QTextDocumentFragment::fromPlainText(test);
    //cursor.insertFragment(headerFrag);
    //TESTTESTSETS

    setHeader(firstBlock());

    QTextCursor cursor(this);
    cursor.movePosition(QTextCursor::End);
    cursor.insertBlock();
    setLegend(lastBlock());

    cursor.movePosition(QTextCursor::End);
    cursor.insertBlock();

    QTextBlockFormat format = cursor.blockFormat();
    format.setPageBreakPolicy(QTextFormat::PageBreak_AlwaysAfter);
    cursor.setBlockFormat(format);

    addGraph(lastBlock());

    cursor.movePosition(QTextCursor::End);
    setData(cursor);

    //TESTTESTSETS
    //test = "<a href=\"#test\"> Should like to above </a>";
    //cursor.insertHtml(test);
    //QTextDocumentFragment testfrag
    //        = QTextDocumentFragment::fromPlainText("test\n");
    //cursor.insertFragment(testfrag);
    //TESTTESTSETS
}

QTextDocumentFragment PlotLvN::contents()
{
    if (isEmpty()) populateDocument();
    QTextCursor cursor(this);
    cursor.movePosition(QTextCursor::Start, QTextCursor::MoveAnchor);
    cursor.movePosition(QTextCursor::End, QTextCursor::KeepAnchor);
    return cursor.selection();
}

void PlotLvN::setHeader(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    QTextCharFormat headerCharF = block.charFormat();
    headerCharF.setFontPointSize(30);
    headerCharF.setFontWeight(QFont::Bold);
    cursor.setBlockCharFormat(headerCharF);

    QString header= prefix() + " LvsN plot: ";
    QTextDocumentFragment headerFrag
            = QTextDocumentFragment::fromPlainText(header);
    cursor.insertFragment(headerFrag);

    headerFrag = QTextDocumentFragment::fromPlainText(scatterData.getName() + "\n");
    cursor.insertFragment(headerFrag);
}

void PlotLvN::setLegend(QTextBlock block)
{
    QTextCursor cursor=QTextCursor(block);
    QTextCharFormat headerCharF = block.charFormat();
    headerCharF.setFontPointSize(16);
    headerCharF.setFontWeight(QFont::Normal);
    cursor.setBlockCharFormat(headerCharF);

    for ( int i=0 ; i < scatterData.x.size() ; i++ )
    {
        QString text = scatterData.label.at(i);
        QString tag = text.left(2);
        QString name1 = nameFromTag(tag);
        QString insertString = tag + " = " + name1 + "\n";
        qDebug() << text << tag << name1 << insertString;
        QTextDocumentFragment frag
                = QTextDocumentFragment::fromPlainText(insertString);
        cursor.insertFragment(frag);
    }
    QTextDocumentFragment frag
            = QTextDocumentFragment::fromPlainText("\n");
    cursor.insertFragment(frag);

}

void PlotLvN::setData(QTextCursor cursor)
{
    cursor.insertTable(scatterData.label.size()+1 ,3);
    cursor.insertText("Assembler");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("N75");
    cursor.movePosition(QTextCursor::NextCell);
    cursor.insertText("Liklyhood");
    cursor.movePosition(QTextCursor::NextCell);

    for ( int i=0 ; i < scatterData.x.size() ; i++ )
    {
        cursor.insertText(scatterData.label.at(i));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(QString::number(scatterData.x.at(i)));
        cursor.movePosition(QTextCursor::NextCell);
        cursor.insertText(QString::number(scatterData.y.at(i)));
        cursor.movePosition(QTextCursor::NextCell);
    }
}

void PlotLvN::writeToPdf()
{
    if (isEmpty()) populateDocument();
    QString pdfFilename = workDir + "/" + prefix() + "_" + scatterData.getName() + ".pdf";
    QPdfWriter* pdfWriter = new QPdfWriter(pdfFilename);
    pdfWriter->setPageSize(QPageSize(QPageSize::A3));
    pdfWriter->setTitle(prefix() + "Liklyhood vrs N75");
    print(pdfWriter);
}

QString PlotLvN::nameFromTag(QString tag) const
{
    QString name;
    QString head = tag.left(tag.size()-1);
    char tail = tag.at(tag.size()-1).cell();

    QVector<RecipieList::Recipie> recipies = recipieList.recipiesData();
    for ( int i = 0 ; i < recipies.size() ; ++i )
    {
        if (recipies.at(i).tag == head)
        {
            name = recipies.at(i).name;
            break;
        }
    }
    switch (tail){
        case 's'  :
           name += " scaffolds";
           break;
        case 'c'  :
           name += " contigs";
           break;
        default :
           ;
    }
    return name;
}

QString PlotLvN::prefix() const
{
    QString text = scatterData.label.at(0);
    text = text.right(text.size()-2);
    text = text.left(text.size()-1);
    return text;
}































