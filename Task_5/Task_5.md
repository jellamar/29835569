---
# IMPORTANT: Change settings here, but DO NOT change the spacing AT ALL.
# Remove comments and add values where applicable.
# The descriptions below should be self-explanatory

title: "Helping You Write Academic Papers in R using Texevier"
#subtitle: "This will appear as Right Header"

documentclass: "elsarticle"

# --------- Thesis title (Optional - set to FALSE by default).
# You can move the details below around as you please.
Thesis_FP: FALSE
# Entry1: "An unbelievable study with a title spanning multiple lines."
# Entry2: "\\textbf{Some Guy}" # textbf for bold
# Entry3: "A thesis submitted toward the degree of Doctor of Philosophy"
# Uni_Logo: Tex/Logo.png # Place a logo in the indicated location (from your root, e.g. defaults to ~/Tex/Logo.png) and uncomment this line. Leave uncommented for no image
# Logo_width: 0.3 # If using a logo - use this to set width (size) of image
# Entry4: "Under the supervision of: \\vfill Prof. Joe Smith and Dr. Frank Smith"
# Entry5: "Stellenbosch University"
# Entry6: April 2020
# Entry7:
# Entry8:

# --------- Front Page
# Comment: ----- Follow this pattern for up to 5 authors
AddTitle: TRUE # Use FALSE when submitting to peer reviewed platform. This will remove author names.
Author1: "Jane Doe^[__Contributions:__  \\newline _The authors would like to thank no institution for money donated to this project. Thank you sincerely._]"  # First Author - note the thanks message displayed as an italic footnote of first page.
Ref1: "Some Institution, Cape Town, South Africa" # First Author's Affiliation
Email1: "nfkatzke\\@gmail.com" # First Author's Email address
# 
# Author2: "John Smith"
# Ref2: "Some other Institution, Cape Town, South Africa"
# Email2: "John\\@gmail.com"
# CommonAffiliation_12: TRUE # If Author 1 and 2 have a common affiliation. Works with _13, _23, etc.
# 
# Author3: "John Doe"
# Email3: "Joe\\@gmail.com"
# 
# CorrespAuthor_1: TRUE  # If corresponding author is author 3, e.g., use CorrespAuthor_3: TRUE
# 
# # Comment out below to remove both. JEL Codes only given if keywords also given.
# keywords: "Multivariate GARCH \\sep Kalman Filter \\sep Copula" # Use \\sep to separate
# JELCodes: "L250 \\sep L100"

# ----- Manage headers and footers:
#BottomLFooter: $Title$
#BottomCFooter:
#TopLHeader: \leftmark # Adds section name at topleft. Remove comment to add it.
BottomRFooter: "\\footnotesize Page \\thepage" # Add a '#' before this line to remove footer.
addtoprule: TRUE
addfootrule: TRUE               # Use if footers added. Add '#' to remove line.

# --------- page margins:
margin: 2.3 # Sides
bottom: 2 # bottom
top: 2.5 # Top
HardSet_layout: TRUE # Hard-set the spacing of words in your document. This will stop LaTeX squashing text to fit on pages, e.g.
# This is done by hard-setting the spacing dimensions. Set to FALSE if you want LaTeX to optimize this for your paper.

# --------- Line numbers
linenumbers: FALSE # Used when submitting to journal

# ---------- References settings:
# You can download cls format here: https://www.zotero.org/ - simply search for your institution. You can also edit and save cls formats here: https://editor.citationstyles.org/about/
# Hit download, store it in Tex/ folder, and change reference below - easy.
bibliography: Tex/ref.bib       # Do not edit: Keep this naming convention and location.
csl: Tex/harvard-stellenbosch-university.csl # referencing format used.
# By default, the bibliography only displays the cited references. If you want to change this, you can comment out one of the following:
#nocite: '@*' # Add all items in bibliography, whether cited or not
# nocite: |  # add specific references that aren't cited
#  @grinold2000
#  @Someoneelse2010

# ---------- General:
RemovePreprintSubmittedTo: TRUE  # Removes the 'preprint submitted to...' at bottom of titlepage
#Journal: "Journal of Finance"   # Journal that the paper will be submitting to, if RemovePreprintSubmittedTo is set to TRUE.
toc: FALSE                       # Add a table of contents
numbersections: TRUE             # Should sections (and thus figures and tables) be numbered?
fontsize: 11pt                  # Set fontsize
linestretch: 1.2                # Set distance between lines.
link-citations: TRUE            # This creates dynamic links to the papers in reference list.

### Adding additional latex packages:
# header-includes:
#    - \usepackage{colortbl} # Add additional packages here.

output:
    powerpoint_presentation:
        keep_md: true
  # pdf_document:
  #   keep_tex: TRUE
  #   template: Tex/TexDefault.txt
    fig_width: 3.5 # Adjust default figure sizes. This can also be done in the chunks of the text.
    fig_height: 3.5
#abstract: |
 # Abstract to be written here. The abstract should not be too long and should provide the reader with a good understanding what you are writing about. Academic papers are not like novels where you keep the reader in suspense. To be effective in getting others to read your paper, be as open and concise about your findings here as possible. Ideally, upon reading your abstract, the reader should feel he / she must read your paper in entirety.
---

<!-- First: Set your default preferences for chunk options: -->

<!-- If you want a chunk's code to be printed, set echo = TRUE. message = FALSE stops R printing ugly package loading details in your final paper too. I also suggest setting warning = FALSE and checking for warnings in R, else you might find ugly warnings in your paper. -->




<!-- ############################## -->
<!-- # Start Writing here: -->
<!-- ############################## -->

# Introduction \label{Introduction}

References are to be made as follows: @fama1997[p. 33] and @grinold2000 Such authors could also be referenced in brackets [@grinold2000] and together [@fama1997 \& @grinold2000]. Source the reference code from scholar.google.com by clicking on ``cite'' below article name. Then select BibTeX at the bottom of the Cite window, and proceed to copy and paste this code into your ref.bib file, located in the directory's Tex folder. Open this file in Rstudio for ease of management, else open it in your preferred Tex environment. Add and manage your article details here for simplicity - once saved, it will self-adjust in your paper.

> I suggest renaming the top line after \@article, as done in the template ref.bib file, to something more intuitive for you to remember. Do not change the rest of the code. Also, be mindful of the fact that bib references from google scholar may at times be incorrect. Reference Latex forums for correct bibtex notation.

To reference a section, you have to set a label using ``\\label'' in R, and then reference it in-text as e.g. referencing a later section, Section \ref{Meth}.

Writing in Rmarkdown is surprizingly easy - see [this website](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf) cheatsheet for a summary on writing Rmd writing tips.

# Data  {-}

Notice how I used the curly brackets and dash to remove the numbering of the data section.

Discussion of data should be thorough with a table of statistics and ideally a figure.

In your tempalte folder, you will find a Data and a Code folder. In order to keep your data files neat, store all of them in your Data folder. Also, I strongly suggest keeping this Rmd file for writing and executing commands, not writing out long pieces of data-wrangling. In the example below, I simply create a ggplot template for scatter plot consistency. I suggest keeping all your data in a data folder.

<!-- The following is a code chunk. It must have its own unique name (after the r), or no name. After the comma follows commands for R which are self-explanatory. By default, the code and messages will not be printed in your pdf, just the output: -->




To reference the plot above, add a ``\\label'' after the caption in the chunk heading, as done above. Then reference the plot as such: As can be seen, Figures \ref{Figure1}  and \ref{Figure2} are excellent, with Figure \ref{Figure2} being particularly aesthetically pleasing due to its device setting of Tikz. The nice thing now is that it correctly numbers all your figures (and sections or tables) and will update if it moves. The links are also dynamic.

I very strongly suggest using ggplot2 (ideally in combination with dplyr) using the ggtheme package to change the themes of your figures.

Also note the information that I have placed above the chunks in the code chunks for the figures. You can edit any of these easily - visit the Rmarkdown webpage for more information.

# Splitting a page


# References {-}

<div id="refs"></div>


# Appendix {-}

## Appendix A {-}

Some appendix information here

## Appendix B {-}

