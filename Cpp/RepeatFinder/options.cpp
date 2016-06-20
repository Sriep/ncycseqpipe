#include <stdexcept>
#include "options.h"
#include "cassert"
#include "iostream"
#include "main.h"

static const int showHelp = 1;
static const int showVersion = 1;
const string Options::shortOptions = "p:i:a:P:I:c:hv";
const string Options::optionIndexes = "piaPIchv";
string Options::commandLine="";
const struct option Options::longOptions[NumOptionTypes+1] =
{
    {"in-pbbamfile", required_argument, NULL, shortOptions[0]}
    ,{"in-illuminabamfile", required_argument, NULL, shortOptions[1]}
    ,{"in-asembly", required_argument, NULL, shortOptions[2]}
     ,{"in-pbrawreads", required_argument, NULL, shortOptions[3]}
     ,{"in-illuminaraw reads", required_argument, NULL, shortOptions[4]}

    ,{"out-results", required_argument, NULL, shortOptions[5]}

    ,{"Coverage-threshold", required_argument, NULL, shortOptions[6]}

    ,{"help", no_argument, &flags[4], showHelp}
    ,{"version", no_argument, &flags[5], showVersion}
    ,{NULL, 0, NULL, 0}
};
const string Options::descriptions[NumOptionTypes] =
{
    "Input PacBio bamfile"
    ,"Input Illumina bamfile"
    ,"Input assembly"
    ,"Input PacBio rawreads"
    ,"Input Illumina raw reads"

    ,"Output results as VCF file"

    ,"Threshold coverfage for calling a pSNP"

    ,"Help information"
    ,"Show program version information"
};
const string Options::defaults[NumOptionTypes] =
{
    "" //InBamFile
    ,"" //TemplateFile
    ,"" //BaxH5File
    ,"" //ReadOutFile
    ,"" //LociOutFile

    /// Out Files
    ,"" //BionomialFile

    /// Algorithm parameters
    ,"0" //CoverageThreshold

    ,"" //Help
    ,"" //Version
    //NumOptionTypes
};

string Options::values[NumOptionTypes] = defaults;
int Options::flags[NumOptionTypes] = {};

Options::Options()
{
}

string Options::get(Options::OptionTypes option)
{
    return values[option];
}

int Options::flag(Options::OptionTypes flag)
{
    return flags[flag];
}

void Options::readOptions(int argc, char *argv[])
{
    for (int i = 0 ; i < argc ; i++) commandLine += argv[i];

    int optionIndex = 0;
    int option = -1;
    bool finished = false;
    do
    {
        option = getopt_long(argc, argv
                                  ,shortOptions.c_str()
                                  ,longOptions
                                  ,&optionIndex);

        finished = (option == -1);
        if (!finished && 0 != option && '?' != option)
        {
            const unsigned int index = optionIndexes.find_first_of(option);
            if (index < optionIndexes.size())
            {
                if (NULL == optarg)
                {
                    flags[index] = longOptions[index].val;
                }
                else
                {
                    values[index].assign(optarg);
                }
            }
            else
            {
                throw(std::invalid_argument("Unrecognised option" + option));
            }
        }
    } while(!finished);

    if (flag(Options::Help)) writeHelpInfo(cout);
    if (flag(Options::Version)) writeVersion(cout);
}

void Options::writeHelpInfo(ostream& outs)
{
    outs << "Help infomation for " << programName << " " << version << '\n';
    for ( unsigned int i = 0 ; i < NumOptionTypes ; i++ )
    {
        outs << "[" << optionIndexes[i] << ']'
             << '\t' << "[" << longOptions[i].name << ']'
             << '\t'<<  "default: " << defaults[i] << '\n';
        outs << '\t' << '\t' << descriptions[i] << '\n';
    }
    outs << '\n';
}


void Options::writeVersion(ostream& outs)
{
    outs << "Version " << version << '\n';
}






















