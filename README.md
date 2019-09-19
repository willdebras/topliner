
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Introduction

Topliner is an R package designed to help produce topline findings
documents automatically from datasets read into R, sidestepping the
potential error of copy and pasting or filling numbers into word tables
from output frequencies. It both promotes transparency by giving a
code-based source for associated tables, reduces error, and saves a
tremendous amount of time by eliminating the need to produce tables in
Microsoft Word, fill them, and number check them.

The package can be used by running simple commands to output a table.

## How to use it

### Installation

If we don’t already have the package installed, we will want to install
it from NORC’s internal bitbucket. We will need to use the
`install_bitbucket` command.

First install devtools if you don’t have it and load it, then install
the topliner package. It will have several dependencies that will need
to be installed. You can interact with the console to install these when
it prompts you.

``` r

install.packages("devtools")

library(devtools)

install_bitbucket("bonnell-william/topliner")
```

Next let’s load the packages we will need. We will need {topliner} to
create the tables and haven to load our data. Install {haven} if you
don’t already have it, otherwise load it. I also load {knitr} to
include images, such as a document header specific to our department.

``` r
library(topliner)
library(haven)
library(knitr)
```

### Reading data and setup

Next, we load in our data with the `haven::read_dta` command. We read
either as a .sav or .dta file extension because {haven} will preserve
the formats and question text associated with the dataset. If you use a
sas dataset, we recommend exporting to a .dta in sas and then reading it
in with this
code.

``` r
data2 <- read_dta("P:\\AP-NORC Center\\Common\\AP Special Projects\\Omnibus\\05.2019\\Data\\old\\May_completes_clean.dta")
```

After we read in the data, convert the columns to factors so {topliner}
recognizes that each variable should have levels. Then we can run the
setup command. The setup command takes a data argument, a caseids
argument, a weights argument, and a dates argument.

Supply the data argument below as the dataframe object you read in.
Supply the caseids argument as the column of your dataframe that
represents the caseid. Supply the weights argument as the column of your
dataframe that represents the sample weights of the survey. Supply the
dates as the field dates for which the survey was fielded.

For non-sample weighted surveys, create a new variable with a value of 1
for every observation and use that variable as the weights argument.

Make sure to supply the caseids, weights, and dates arguments as
strings, as they are not objects the function can detect. If used
outside of APNORC, set APNORC = FALSE.

``` r

data2 <- as_factor(data2)

tl_setup(data = data2, caseids = "caseid", weights = "weight_enes", dates = "05/17-20/2019", APNORC = TRUE)
```

This setup function will superassign to the global environment three
objects to be referenced by our functions:

  - a dataframe called `nsize` with the nsizes of each column
  - a survey object called `tl_df` for reference by our functions
  - a string called `battery_fill` to include in the header of functions

### Labels, formats, logic

To produce the question text, grid battery item text, skip logic, and
question logic in a topline we want to run the `tl_labels` function on
the dataset we initially provided.

``` r
tl_labels(data2)
```

We run this function and it produces a temporary excel file that looks
like this:

<img src="H:\New fldr\labels_example.png" width="100%" />

If the question labels produced in SAS/Stata/SPSS have been truncated,
we will want to fill them in in this excel sheet.

For standard, non-battery/grid questions, we edit the “label” column to
be complete. For battery/grid questions, this function splits the string
of the battery item contained in brackets \[\] from the question text.
We edit the “battery\_labels” column to be the battery item and we edit
the “question\_label” of the first item in the battery to the associated
question text.

E.g., in this screenshot we have a battery from qp3a to sp3i. We want
the column question\_labels in the row of sp3a to be the full question
text of the battery. This will be referenced in the battery function.

We can then edit the “skip\_logic” column to show up in italics before
the question text and the “question\_logic” to show up in bold after the
question text.

Once done we will want to save this somewhere and load it in as a csv,
assigned to the object name “data\_labels.” Our functions will reference
the object “data\_labels” by default.

### Trend data

If we have historical trend data, we load in a an excel sheet with
tables we want to match to new data. This should be a workbook that has
the appropriate netting, column names, and row names, where each sheet
name is that of the question referenced in our new dataset.. It should
look something like this:

<img src="H:\New fldr\trendbook.png" width="100%" />

Load it in and assign it to a name that we will reference in the trend
function.

``` r

mysheets <- tl_readexcel("H:\\New fldr\\trend_book.xlsx")
```

### The functions

#### Trends

We can test the trend function now with the question “cur1” seen in the
sheet above:

Run `tl_trend` supplying the name of the workbook assigned above:

<font size="4">

``` r
tl_trend("cur1", trends = mysheets)
```

<br /><br /><b>CUR1. Generally speaking, would you say things in this
country are heading in the?</b><br /><br /><b>\[HALF SAMPLE ASKED
RESPONSE OPTIONS IN REVERSE ORDER\]</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#hqxpitpqih .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#hqxpitpqih .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#hqxpitpqih .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hqxpitpqih .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hqxpitpqih .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#hqxpitpqih .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#hqxpitpqih .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#hqxpitpqih .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#hqxpitpqih .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hqxpitpqih .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#hqxpitpqih .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#hqxpitpqih .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#hqxpitpqih .gt_striped {
  background-color: #8080800D;
}

#hqxpitpqih .gt_from_md > :first-child {
  margin-top: 0;
}

#hqxpitpqih .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hqxpitpqih .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hqxpitpqih .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#hqxpitpqih .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#hqxpitpqih .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#hqxpitpqih .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#hqxpitpqih .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hqxpitpqih .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#hqxpitpqih .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#hqxpitpqih .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#hqxpitpqih .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#hqxpitpqih .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#hqxpitpqih .gt_center {
  text-align: center;
}

#hqxpitpqih .gt_left {
  text-align: left;
}

#hqxpitpqih .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hqxpitpqih .gt_font_normal {
  font-weight: normal;
}

#hqxpitpqih .gt_font_bold {
  font-weight: bold;
}

#hqxpitpqih .gt_font_italic {
  font-style: italic;
}

#hqxpitpqih .gt_super {
  font-size: 65%;
}

#hqxpitpqih .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="hqxpitpqih" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

AP-NORC

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Right
direction

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Wrong
direction

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Don’t
know

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Skipped on web/Refused

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

05/17-20/2019 (N=1,137)

</td>

<td class="gt_row gt_center">

35

</td>

<td class="gt_row gt_center">

62

</td>

<td class="gt_row gt_center">

2

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

5/17-20/2019 (N=1,137)

</td>

<td class="gt_row gt_center gt_striped">

35

</td>

<td class="gt_row gt_center gt_striped">

62

</td>

<td class="gt_row gt_center gt_striped">

2

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

4/11-14/2019 (N=1,108)

</td>

<td class="gt_row gt_center">

37

</td>

<td class="gt_row gt_center">

62

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

3/14-18/2019 (N=1,063)

</td>

<td class="gt_row gt_center gt_striped">

35

</td>

<td class="gt_row gt_center gt_striped">

63

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

1/16-20/2019 (N=1,062)

</td>

<td class="gt_row gt_center">

28

</td>

<td class="gt_row gt_center">

70

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

\*

</td>

</tr>

</body>

</table>

</div>

<!--/html_preserve-->

</font>

#### Standard questions

For ordinary questions we can use the `tl_tib` function. It takes
several arguments that default based on the setup above. We can just
supply the `vari` argument as the column name we want to produce a table
for.

<font size="4">

``` r
tl_tib(vari = "sp5")
```

<br /><br /><b>SP5. Do you favor, oppose, or neither favor nor oppose
the United States space program returning astronauts to the moon within
five years?</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#arkrmiqfsv .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#arkrmiqfsv .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#arkrmiqfsv .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#arkrmiqfsv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#arkrmiqfsv .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#arkrmiqfsv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#arkrmiqfsv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#arkrmiqfsv .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#arkrmiqfsv .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#arkrmiqfsv .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#arkrmiqfsv .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#arkrmiqfsv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#arkrmiqfsv .gt_striped {
  background-color: #8080800D;
}

#arkrmiqfsv .gt_from_md > :first-child {
  margin-top: 0;
}

#arkrmiqfsv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#arkrmiqfsv .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#arkrmiqfsv .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#arkrmiqfsv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#arkrmiqfsv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#arkrmiqfsv .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#arkrmiqfsv .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#arkrmiqfsv .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#arkrmiqfsv .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#arkrmiqfsv .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#arkrmiqfsv .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#arkrmiqfsv .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#arkrmiqfsv .gt_center {
  text-align: center;
}

#arkrmiqfsv .gt_left {
  text-align: left;
}

#arkrmiqfsv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#arkrmiqfsv .gt_font_normal {
  font-weight: normal;
}

#arkrmiqfsv .gt_font_bold {
  font-weight: bold;
}

#arkrmiqfsv .gt_font_italic {
  font-style: italic;
}

#arkrmiqfsv .gt_super {
  font-size: 65%;
}

#arkrmiqfsv .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="arkrmiqfsv" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

AP-NORC <br /> 05/17-20/2019

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left" style="font-weight: bold;">

Top NET

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

42

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Strongly favor

</td>

<td class="gt_row gt_center gt_striped">

17

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Somewhat favor

</td>

<td class="gt_row gt_center">

25

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-weight: bold;">

Neither favor nor oppose

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

38

</td>

</tr>

<tr>

<td class="gt_row gt_left" style="font-weight: bold;">

Bot NET

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

20

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Somewhat oppose

</td>

<td class="gt_row gt_center gt_striped">

11

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Strongly oppose

</td>

<td class="gt_row gt_center">

8

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

DON’T KNOW

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left">

SKIPPED/REFUSED

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="2">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

If you notice, this function will default to do two things:

  - net the top and bottom columns if there are four, five, or seven
    levels in your categorical variable.
  - net the bottom two columns of “skipped on web” and “refused” into a
    single column

These defaults can be changed. Here we tell it to not default anything.

<font size="4">

``` r
tl_tib(vari = "sp5", default = FALSE)
```

<br /><br /><b>SP5. Do you favor, oppose, or neither favor nor oppose
the United States space program returning astronauts to the moon within
five years?</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qefhswkexg .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#qefhswkexg .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#qefhswkexg .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qefhswkexg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qefhswkexg .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#qefhswkexg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#qefhswkexg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#qefhswkexg .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#qefhswkexg .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qefhswkexg .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#qefhswkexg .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#qefhswkexg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#qefhswkexg .gt_striped {
  background-color: #8080800D;
}

#qefhswkexg .gt_from_md > :first-child {
  margin-top: 0;
}

#qefhswkexg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qefhswkexg .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qefhswkexg .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#qefhswkexg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#qefhswkexg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#qefhswkexg .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#qefhswkexg .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qefhswkexg .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#qefhswkexg .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#qefhswkexg .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#qefhswkexg .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#qefhswkexg .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#qefhswkexg .gt_center {
  text-align: center;
}

#qefhswkexg .gt_left {
  text-align: left;
}

#qefhswkexg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qefhswkexg .gt_font_normal {
  font-weight: normal;
}

#qefhswkexg .gt_font_bold {
  font-weight: bold;
}

#qefhswkexg .gt_font_italic {
  font-style: italic;
}

#qefhswkexg .gt_super {
  font-size: 65%;
}

#qefhswkexg .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="qefhswkexg" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

AP-NORC <br /> 05/17-20/2019

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Strongly favor

</td>

<td class="gt_row gt_center">

17

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Somewhat favor

</td>

<td class="gt_row gt_center gt_striped">

25

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Neither favor nor oppose

</td>

<td class="gt_row gt_center">

38

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Somewhat oppose

</td>

<td class="gt_row gt_center gt_striped">

11

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Strongly oppose

</td>

<td class="gt_row gt_center">

8

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

DON’T KNOW

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left">

SKIPPED/REFUSED

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="2">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

Here we tell it to custom net just the bottom two levels.

<font size="4">

``` r
tl_tib(vari = "sp5", bot = 2)
```

<br /><br /><b>SP5. Do you favor, oppose, or neither favor nor oppose
the United States space program returning astronauts to the moon within
five years?</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mpgffhclbr .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#mpgffhclbr .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#mpgffhclbr .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#mpgffhclbr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mpgffhclbr .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#mpgffhclbr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#mpgffhclbr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#mpgffhclbr .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#mpgffhclbr .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mpgffhclbr .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#mpgffhclbr .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#mpgffhclbr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#mpgffhclbr .gt_striped {
  background-color: #8080800D;
}

#mpgffhclbr .gt_from_md > :first-child {
  margin-top: 0;
}

#mpgffhclbr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mpgffhclbr .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#mpgffhclbr .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#mpgffhclbr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#mpgffhclbr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#mpgffhclbr .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#mpgffhclbr .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mpgffhclbr .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#mpgffhclbr .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#mpgffhclbr .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#mpgffhclbr .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#mpgffhclbr .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#mpgffhclbr .gt_center {
  text-align: center;
}

#mpgffhclbr .gt_left {
  text-align: left;
}

#mpgffhclbr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mpgffhclbr .gt_font_normal {
  font-weight: normal;
}

#mpgffhclbr .gt_font_bold {
  font-weight: bold;
}

#mpgffhclbr .gt_font_italic {
  font-style: italic;
}

#mpgffhclbr .gt_super {
  font-size: 65%;
}

#mpgffhclbr .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="mpgffhclbr" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

AP-NORC <br /> 05/17-20/2019

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Strongly favor

</td>

<td class="gt_row gt_center">

17

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Somewhat favor

</td>

<td class="gt_row gt_center gt_striped">

25

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Neither favor nor oppose

</td>

<td class="gt_row gt_center">

38

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped" style="font-weight: bold;">

Bot NET

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

20

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Somewhat oppose

</td>

<td class="gt_row gt_center">

11

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Strongly oppose

</td>

<td class="gt_row gt_center gt_striped">

8

</td>

</tr>

<tr>

<td class="gt_row gt_left">

DON’T KNOW

</td>

<td class="gt_row gt_center">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

SKIPPED/REFUSED

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="2">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

Here wee tell it to custom net the top three and bottom two.

<font size="4">

``` r
tl_tib(vari = "sp5", top =3, bot = 2)
```

<br /><br /><b>SP5. Do you favor, oppose, or neither favor nor oppose
the United States space program returning astronauts to the moon within
five years?</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#zqnabeoguk .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#zqnabeoguk .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#zqnabeoguk .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#zqnabeoguk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#zqnabeoguk .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#zqnabeoguk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#zqnabeoguk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#zqnabeoguk .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#zqnabeoguk .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zqnabeoguk .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#zqnabeoguk .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#zqnabeoguk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#zqnabeoguk .gt_striped {
  background-color: #8080800D;
}

#zqnabeoguk .gt_from_md > :first-child {
  margin-top: 0;
}

#zqnabeoguk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zqnabeoguk .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#zqnabeoguk .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#zqnabeoguk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#zqnabeoguk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#zqnabeoguk .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#zqnabeoguk .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zqnabeoguk .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#zqnabeoguk .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#zqnabeoguk .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#zqnabeoguk .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#zqnabeoguk .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#zqnabeoguk .gt_center {
  text-align: center;
}

#zqnabeoguk .gt_left {
  text-align: left;
}

#zqnabeoguk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zqnabeoguk .gt_font_normal {
  font-weight: normal;
}

#zqnabeoguk .gt_font_bold {
  font-weight: bold;
}

#zqnabeoguk .gt_font_italic {
  font-style: italic;
}

#zqnabeoguk .gt_super {
  font-size: 65%;
}

#zqnabeoguk .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="zqnabeoguk" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

AP-NORC <br /> 05/17-20/2019

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left" style="font-weight: bold;">

Top NET

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

80

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Strongly favor

</td>

<td class="gt_row gt_center gt_striped">

17

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Somewhat favor

</td>

<td class="gt_row gt_center">

25

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Neither favor nor oppose

</td>

<td class="gt_row gt_center gt_striped">

38

</td>

</tr>

<tr>

<td class="gt_row gt_left" style="font-weight: bold;">

Bot NET

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

20

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Somewhat oppose

</td>

<td class="gt_row gt_center gt_striped">

11

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Strongly oppose

</td>

<td class="gt_row gt_center">

8

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

DON’T KNOW

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left">

SKIPPED/REFUSED

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="2">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

The function has a default parameter `res = 3` that tells the function
to expect three “residual” columns:

  - don’t know
  - skipped on web
  - refused

If we specify res = 0, in the case of a demo variable with no missings,
or less than 3 in a case where we have a web-only survey with no active
“don’t know” or “refused” column it will not combine the bottom two
variables.

Here we supply it a seven level variable that we do not want netted and
has no residual columns since it is a demographic:

<font size="4">

``` r
tl_tib("age7", default = FALSE, res = 0)
```

<br /><br /><b>AGE7. Age - 7
Categories</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ptaiwgzgam .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#ptaiwgzgam .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#ptaiwgzgam .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ptaiwgzgam .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ptaiwgzgam .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#ptaiwgzgam .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#ptaiwgzgam .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#ptaiwgzgam .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ptaiwgzgam .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ptaiwgzgam .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#ptaiwgzgam .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#ptaiwgzgam .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#ptaiwgzgam .gt_striped {
  background-color: #8080800D;
}

#ptaiwgzgam .gt_from_md > :first-child {
  margin-top: 0;
}

#ptaiwgzgam .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ptaiwgzgam .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ptaiwgzgam .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ptaiwgzgam .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#ptaiwgzgam .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#ptaiwgzgam .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ptaiwgzgam .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ptaiwgzgam .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#ptaiwgzgam .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#ptaiwgzgam .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#ptaiwgzgam .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#ptaiwgzgam .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#ptaiwgzgam .gt_center {
  text-align: center;
}

#ptaiwgzgam .gt_left {
  text-align: left;
}

#ptaiwgzgam .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ptaiwgzgam .gt_font_normal {
  font-weight: normal;
}

#ptaiwgzgam .gt_font_bold {
  font-weight: bold;
}

#ptaiwgzgam .gt_font_italic {
  font-style: italic;
}

#ptaiwgzgam .gt_super {
  font-size: 65%;
}

#ptaiwgzgam .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="ptaiwgzgam" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

AP-NORC <br /> 05/17-20/2019

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

18-24

</td>

<td class="gt_row gt_center">

12

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

25-34

</td>

<td class="gt_row gt_center gt_striped">

19

</td>

</tr>

<tr>

<td class="gt_row gt_left">

35-44

</td>

<td class="gt_row gt_center">

15

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

45-54

</td>

<td class="gt_row gt_center gt_striped">

16

</td>

</tr>

<tr>

<td class="gt_row gt_left">

55-64

</td>

<td class="gt_row gt_center">

18

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

65-74

</td>

<td class="gt_row gt_center gt_striped">

13

</td>

</tr>

<tr>

<td class="gt_row gt_left">

75+

</td>

<td class="gt_row gt_center">

8

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Under 18

</td>

<td class="gt_row gt_center gt_striped">

\-

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="2">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

These net and residual arguments will work for standard questions,
batteries, and trends.

#### Battery questions

Battery questions work in a similar manner except we supply a vector of
questions as the “vars” argument. Here is an example. You’ll notice it
has custom question logic piped in from the data\_labels excel sheet we
gave it earlier.

<font size="4">

``` r
tl_bat(vars = c("sp7a", "sp7b", "sp7c"))
```

<br /><br /><b>SP7. If you had a chance to do each of the following,
would you do so, or not?</b><br /><br /><b>\[ITEMS
RANDOMIZED\]</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#zaxizaxarg .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#zaxizaxarg .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#zaxizaxarg .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#zaxizaxarg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#zaxizaxarg .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#zaxizaxarg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#zaxizaxarg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#zaxizaxarg .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#zaxizaxarg .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zaxizaxarg .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#zaxizaxarg .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#zaxizaxarg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#zaxizaxarg .gt_striped {
  background-color: #8080800D;
}

#zaxizaxarg .gt_from_md > :first-child {
  margin-top: 0;
}

#zaxizaxarg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zaxizaxarg .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#zaxizaxarg .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#zaxizaxarg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#zaxizaxarg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#zaxizaxarg .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#zaxizaxarg .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zaxizaxarg .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#zaxizaxarg .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#zaxizaxarg .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#zaxizaxarg .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#zaxizaxarg .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#zaxizaxarg .gt_center {
  text-align: center;
}

#zaxizaxarg .gt_left {
  text-align: left;
}

#zaxizaxarg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zaxizaxarg .gt_font_normal {
  font-weight: normal;
}

#zaxizaxarg .gt_font_bold {
  font-weight: bold;
}

#zaxizaxarg .gt_font_italic {
  font-style: italic;
}

#zaxizaxarg .gt_super {
  font-size: 65%;
}

#zaxizaxarg .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="zaxizaxarg" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

AP-NORC <br />
05/17-20/2019

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Yes

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

No

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

DON’T
KNOW

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

SKP/REF

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Orbit the Earth

</td>

<td class="gt_row gt_center">

52

</td>

<td class="gt_row gt_center">

46

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Travel to the moon

</td>

<td class="gt_row gt_center gt_striped">

41

</td>

<td class="gt_row gt_center gt_striped">

58

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Travel to Mars

</td>

<td class="gt_row gt_center">

31

</td>

<td class="gt_row gt_center">

67

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="5">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

These will have default
nets.

<font size="4">

``` r
tl_bat(vars = c("rel3a", "rel3b", "rel3c", "rel3d", "rel3e", "rel3f", "rel3g"))
```

<br /><br /><b>REL3. Thinking about each of the following professions,
would you say their impact on society today is mostly positive, mostly
negative, or neither positive nor negative?</b><br /><br /><b>\[ITEMS
RANDOMIZED\]</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#kkybmqawzy .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#kkybmqawzy .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#kkybmqawzy .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kkybmqawzy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kkybmqawzy .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#kkybmqawzy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#kkybmqawzy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#kkybmqawzy .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#kkybmqawzy .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kkybmqawzy .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#kkybmqawzy .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#kkybmqawzy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#kkybmqawzy .gt_striped {
  background-color: #8080800D;
}

#kkybmqawzy .gt_from_md > :first-child {
  margin-top: 0;
}

#kkybmqawzy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kkybmqawzy .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kkybmqawzy .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#kkybmqawzy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#kkybmqawzy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#kkybmqawzy .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#kkybmqawzy .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kkybmqawzy .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#kkybmqawzy .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#kkybmqawzy .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#kkybmqawzy .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#kkybmqawzy .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#kkybmqawzy .gt_center {
  text-align: center;
}

#kkybmqawzy .gt_left {
  text-align: left;
}

#kkybmqawzy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kkybmqawzy .gt_font_normal {
  font-weight: normal;
}

#kkybmqawzy .gt_font_bold {
  font-weight: bold;
}

#kkybmqawzy .gt_font_italic {
  font-style: italic;
}

#kkybmqawzy .gt_super {
  font-size: 65%;
}

#kkybmqawzy .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="kkybmqawzy" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

AP-NORC <br />
05/17-20/2019

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1" style="font-weight: bold;">

Top
NET

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Very
positive

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Somewhat
positive

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1" style="font-weight: bold;">

Neither positive nor
negative

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1" style="font-weight: bold;">

Bot
NET

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Somewhat
negative

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Very
negative

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

DON’T
KNOW

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

SKP/REF

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Scientists

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

80

</td>

<td class="gt_row gt_center">

45

</td>

<td class="gt_row gt_center">

36

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

13

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

5

</td>

<td class="gt_row gt_center">

3

</td>

<td class="gt_row gt_center">

2

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Clergy members and religious leaders

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

55

</td>

<td class="gt_row gt_center gt_striped">

19

</td>

<td class="gt_row gt_center gt_striped">

36

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

23

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

21

</td>

<td class="gt_row gt_center gt_striped">

15

</td>

<td class="gt_row gt_center gt_striped">

6

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Medical doctors

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

83

</td>

<td class="gt_row gt_center">

47

</td>

<td class="gt_row gt_center">

37

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

11

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

4

</td>

<td class="gt_row gt_center">

3

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Members of the military

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

75

</td>

<td class="gt_row gt_center gt_striped">

40

</td>

<td class="gt_row gt_center gt_striped">

35

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

16

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

7

</td>

<td class="gt_row gt_center gt_striped">

5

</td>

<td class="gt_row gt_center gt_striped">

2

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Lawyers

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

42

</td>

<td class="gt_row gt_center">

10

</td>

<td class="gt_row gt_center">

32

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

32

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

24

</td>

<td class="gt_row gt_center">

17

</td>

<td class="gt_row gt_center">

7

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Business executives

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

40

</td>

<td class="gt_row gt_center gt_striped">

7

</td>

<td class="gt_row gt_center gt_striped">

33

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

34

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

25

</td>

<td class="gt_row gt_center gt_striped">

17

</td>

<td class="gt_row gt_center gt_striped">

8

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Teachers

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

84

</td>

<td class="gt_row gt_center">

55

</td>

<td class="gt_row gt_center">

29

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

8

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

6

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="10">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

We can supply it custom
nets.

<font size="4">

``` r
tl_bat(vars = c("sp3a", "sp3b", "sp3c", "sp3d", "sp3e", "sp3f", "sp3g", "sp3h", "sp3i"), top =2, bot = 3)
```

<br /><br /><b>SP3. How important is it for the United States space
program to do each of the following?</b><br /><br /><b>\[ITEMS
RANDOMIZED\]</b><br /><br /><!--html_preserve-->

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ngvnxgmuud .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  background-color: #FFFFFF;
  /* table.background.color */
  width: auto;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#ngvnxgmuud .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
}

#ngvnxgmuud .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ngvnxgmuud .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ngvnxgmuud .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#ngvnxgmuud .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#ngvnxgmuud .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 16px;
  /* column_labels.font.size */
  font-weight: initial;
  /* column_labels.font.weight */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#ngvnxgmuud .gt_columns_top_border {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ngvnxgmuud .gt_columns_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ngvnxgmuud .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#ngvnxgmuud .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#ngvnxgmuud .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 16px;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#ngvnxgmuud .gt_striped {
  background-color: #8080800D;
}

#ngvnxgmuud .gt_from_md > :first-child {
  margin-top: 0;
}

#ngvnxgmuud .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ngvnxgmuud .gt_row {
  padding: 8px;
  /* row.padding */
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ngvnxgmuud .gt_stub {
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ngvnxgmuud .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  padding: 8px;
  /* summary_row.padding */
  text-transform: inherit;
  /* summary_row.text_transform */
}

#ngvnxgmuud .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  padding: 8px;
  /* grand_summary_row.padding */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
}

#ngvnxgmuud .gt_first_summary_row {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ngvnxgmuud .gt_first_grand_summary_row {
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ngvnxgmuud .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#ngvnxgmuud .gt_footnotes {
  border-top-style: solid;
  /* footnotes.border.top.style */
  border-top-width: 2px;
  /* footnotes.border.top.width */
  border-top-color: #D3D3D3;
  /* footnotes.border.top.color */
}

#ngvnxgmuud .gt_footnote {
  font-size: 90%;
  /* footnote.font.size */
  margin: 0px;
  padding: 4px;
  /* footnote.padding */
}

#ngvnxgmuud .gt_sourcenotes {
  border-top-style: solid;
  /* sourcenotes.border.top.style */
  border-top-width: 2px;
  /* sourcenotes.border.top.width */
  border-top-color: #D3D3D3;
  /* sourcenotes.border.top.color */
}

#ngvnxgmuud .gt_sourcenote {
  font-size: 90%;
  /* sourcenote.font.size */
  padding: 4px;
  /* sourcenote.padding */
}

#ngvnxgmuud .gt_center {
  text-align: center;
}

#ngvnxgmuud .gt_left {
  text-align: left;
}

#ngvnxgmuud .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ngvnxgmuud .gt_font_normal {
  font-weight: normal;
}

#ngvnxgmuud .gt_font_bold {
  font-weight: bold;
}

#ngvnxgmuud .gt_font_italic {
  font-style: italic;
}

#ngvnxgmuud .gt_super {
  font-size: 65%;
}

#ngvnxgmuud .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="ngvnxgmuud" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">

<tr>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_left" rowspan="1" colspan="1">

AP-NORC <br />
05/17-20/2019

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1" style="font-weight: bold;">

Top
NET

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Not at all
important

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Not too
important

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1" style="font-weight: bold;">

Bot
NET

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Moderately
important

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Very
important

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

Extremely
important

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

DON’T
KNOW

</th>

<th class="gt_col_heading gt_columns_bottom_border gt_columns_top_border gt_center" rowspan="1" colspan="1">

SKP/REF

</th>

</tr>

<body class="gt_table_body">

<tr>

<td class="gt_row gt_left">

Return astronauts to the moon

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

40

</td>

<td class="gt_row gt_center">

14

</td>

<td class="gt_row gt_center">

26

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

58

</td>

<td class="gt_row gt_center">

36

</td>

<td class="gt_row gt_center">

15

</td>

<td class="gt_row gt_center">

7

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Continue funding the International Space Station

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

18

</td>

<td class="gt_row gt_center gt_striped">

6

</td>

<td class="gt_row gt_center gt_striped">

12

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

81

</td>

<td class="gt_row gt_center gt_striped">

38

</td>

<td class="gt_row gt_center gt_striped">

29

</td>

<td class="gt_row gt_center gt_striped">

14

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Send astronauts to Mars

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

38

</td>

<td class="gt_row gt_center">

15

</td>

<td class="gt_row gt_center">

22

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

61

</td>

<td class="gt_row gt_center">

34

</td>

<td class="gt_row gt_center">

19

</td>

<td class="gt_row gt_center">

8

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Send robotic probes without astronauts to explore space

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

18

</td>

<td class="gt_row gt_center gt_striped">

7

</td>

<td class="gt_row gt_center gt_striped">

11

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

81

</td>

<td class="gt_row gt_center gt_striped">

34

</td>

<td class="gt_row gt_center gt_striped">

31

</td>

<td class="gt_row gt_center gt_striped">

16

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Continue funding the International Space Station  

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

12

</td>

<td class="gt_row gt_center">

5

</td>

<td class="gt_row gt_center">

7

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

87

</td>

<td class="gt_row gt_center">

28

</td>

<td class="gt_row gt_center">

36

</td>

<td class="gt_row gt_center">

23

</td>

<td class="gt_row gt_center">

\*

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Search for life on other planets

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

33

</td>

<td class="gt_row gt_center gt_striped">

12

</td>

<td class="gt_row gt_center gt_striped">

21

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

66

</td>

<td class="gt_row gt_center gt_striped">

33

</td>

<td class="gt_row gt_center gt_striped">

22

</td>

<td class="gt_row gt_center gt_striped">

12

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

<td class="gt_row gt_center gt_striped">

\*

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Monitor asteroids, comets, and other events in space that could impact
Earth

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

9

</td>

<td class="gt_row gt_center">

3

</td>

<td class="gt_row gt_center">

6

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

90

</td>

<td class="gt_row gt_center">

23

</td>

<td class="gt_row gt_center">

37

</td>

<td class="gt_row gt_center">

31

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left gt_striped">

Establish a permanent human presence on other planets

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

52

</td>

<td class="gt_row gt_center gt_striped">

23

</td>

<td class="gt_row gt_center gt_striped">

28

</td>

<td class="gt_row gt_center gt_striped" style="font-weight: bold;">

47

</td>

<td class="gt_row gt_center gt_striped">

26

</td>

<td class="gt_row gt_center gt_striped">

13

</td>

<td class="gt_row gt_center gt_striped">

8

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

<td class="gt_row gt_center gt_striped">

1

</td>

</tr>

<tr>

<td class="gt_row gt_left">

Establish a U.S. military presence in space

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

51

</td>

<td class="gt_row gt_center">

25

</td>

<td class="gt_row gt_center">

26

</td>

<td class="gt_row gt_center" style="font-weight: bold;">

48

</td>

<td class="gt_row gt_center">

29

</td>

<td class="gt_row gt_center">

11

</td>

<td class="gt_row gt_center">

8

</td>

<td class="gt_row gt_center">

1

</td>

<td class="gt_row gt_center">

1

</td>

</tr>

</body>

<tfoot class="gt_sourcenotes">

<tr>

<td class="gt_sourcenote" colspan="10">

<i>N = 1,137<i/>

</td>

</tr>

</tfoot>

</table>

</div>

<!--/html_preserve-->

</font>

## Tips and tricks

### R Markdown

The shell provided in the bitbucket is a good place to start with
creating a publishable topline document. It includes the rmd parameters
that you will need:

  - Code chunks should generally be given the option `echo = FALSE` if
    you wish for them to not show up.
  - Code chunks should be given the option `results = "asis"` to ensure
    the HTML in the functions, i.e. italics, bolds, and line breaks show
    up in a readable way.
  - The best font size is 3 or 4. We use rmd inline code to tell it this
    in the shell. \*Cover pages and methodology can be included in
    multiple ways. They can be included as images as shown in our
    example or they can be included just by typing or pasting into here
    with different rmd options related to font, hyperlinks, etc. We are
    more than welcome to meet to set up some shells for different
    departments to use.

### Output options

Right now this package can only output to HTML, which can be easily
converted to PDF. We’re currently working on different solutions to get
it to properly output to a LaTeX PDF or MS Word version.

The topliner bitbucket can be found
[here](http://bitbucket.norc.org:7990/projects/TOP). The InSite folder
with reference documents, the tutorial, and our presentation slides can
be found
[here](https://insite2.norc.org/projects/VentureFund/Shared%20Documents/00_All%20Access/2019%20Final%20Deliverables/Round%201/Automated%20Toplines)
