#ifndef OPTIONS_H
#define OPTIONS_H
#include <unistd.h>
#include <string>
#include "getopt.h"

using namespace std;

/**
 * @brief The Options class
 */
class Options
{

public:
    /**
     * @brief The OptionTypes enum
     */
    enum OptionTypes
    {
        InBax
        ,OutPrefix
        ,Distribution
        ,ConfusionTable
        ,Help
        ,Version
        ,NumOptionTypes
    };
    /**
     * @brief Options
     */
    Options();
    /**
     * @brief get
     * @param option
     * @return
     */
    static string get(OptionTypes option);
    /**
     * @brief flag
     * @param flag
     * @return
     */
    static int flag(OptionTypes flag);
    /**
     * @brief readOptions
     * @param argc
     * @param argv
     * @return
     */
    static int readOptions(int argc, char *argv[]);


private:
    static void writeHelpInfo(ostream &outs);
    static void writeVersion(ostream& outs);

    static const string shortOptions;
    static const string optionIndexes;
    static const struct option longOptions[NumOptionTypes+1];
    static const string descriptions[NumOptionTypes];
    static int flags[NumOptionTypes];
    static string values[NumOptionTypes];
    static const string defaults[NumOptionTypes];
};

#endif // OPTIONS_H
