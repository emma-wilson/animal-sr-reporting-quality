# EVALUATING THE REPORTING QUALITY OF NDC ANIMAL SYSTEMATIC REVIEWS ============

# Code written by Emma Wilson
# Tested in R Version 4.2.1

# Load Libraries ---------------------------------------------------------------

library(dplyr)       # Version 1.1.2
library(tidyr)       # Version 1.3.0
library(data.table)  # Version 1.14.8
library(formattable) # Version 0.2.1
library(ggplot2)     # Version 3.4.2
library(forcats)     # Version 1.0.0

# Read in Data -----------------------------------------------------------------

# Cleaned data from SyRF project
dat <- read.csv("data/review_data_clean.csv", stringsAsFactors = F)

# Prospero data on registrations
dat_prospero <- read.csv("data/prospero_data.csv", stringsAsFactors = F)


# Transform Data (Characteristics) ---------------------------------------------

# Select relevant columns
dat_characteristics <- dat[,1:13] %>%
  select(-SyRF_ID,
         -Title,
         -DOI) %>%
  # Merge number of included studies data into one column
  mutate(Characteristics_NStudies = paste0(Characteristics_NTotalStudies,
                                           " (",Characteristics_NAnimalStudies,
                                           ")")) %>%
  # Select and rename columns for table
  select(Author, Year, Journal,
         "Publication Type" = Characteristics_PublicationType,
         "Review Type" = Characteristics_ReviewType,
         "Review Focus" = Characteristics_ReviewAim,
         "Study Types" = Characteristcs_StudyPopulations,
         "Gene Models" = Characteristics_GeneModels,
         "N Included Studies" = Characteristics_NStudies)

# Shorten text in journal column
dat_characteristics$Journal <- gsub("Frontiers in Neuroscience", 
                                    "Front Neurosci", 
                                    dat_characteristics$Journal)
dat_characteristics$Journal <- gsub("Clinical Neurophysiology", 
                                    "Clin Neurophysiol", 
                                    dat_characteristics$Journal)

# Shorten text in publication type column
dat_characteristics$`Review Type` <- gsub("Systematic review only", "SR", 
                                          dat_characteristics$`Review Type`)
dat_characteristics$`Review Type` <- gsub("Systematic review and meta-analysis", 
                                          "SR+MA", 
                                          dat_characteristics$`Review Type`)

# Add an aterisk to Author Zhang (to signify article and conference abstract)
dat_characteristics$Author <- gsub("Zhang", "Zhang\\*", dat_characteristics$Author)

# Order data
dat_characteristics <- dat_characteristics %>%
  arrange(Year, Author)

# Create Summary Table ---------------------------------------------------------

# Generate summary table
formattable(dat_characteristics, 
            align = c("l", "l", "l", "l", "l", "l", "l", "l", "l"))

# Summary table exported from RStudio and saved as a PNG.

# Transform Data (Scoring) -----------------------------------------------------

# Pivot from wide to long format and count the number of studies with each score
dat_scoring <- dat[,c(1,14:64)] %>%
  # Pivot
  pivot_longer(!SyRF_ID, names_to = "item", values_to = "score") %>%
  # Group
  group_by(item, score) %>%
  # Count number of studies
  count()

# Fix score for data sharing
dat_scoring$score <- gsub("Reporte?d? data shared|Reported data are not shared", 
                                "Yes", dat_scoring$score)
dat_scoring$score <- gsub("Not reported",
                                "No", dat_scoring$score)

# Split Data by Section --------------------------------------------------------

# Read in column labels
col_labs <- read.csv("data/column_labels.csv", stringsAsFactors = F) %>%
  select(checklist_ID, item = Label_Short, question = Label_Long)

# Merge with scoring data
dat_scoring <- merge(dat_scoring, col_labs, by = "item") %>%
  arrange(checklist_ID)

# Make NA a character
dat_scoring[is.na(dat_scoring)] <- "Not applicable"

# Make score a factor and set order of levels
dat_scoring$score <- factor(dat_scoring$score,
                                  levels = c("Not applicable", "No", "Yes"))

# Make checklist_ID a factor
dat_scoring$checklist_ID <- factor(dat_scoring$checklist_ID)
dat_scoring$checklist_ID <- fct_rev(dat_scoring$checklist_ID)

# Create Graph -----------------------------------------------------------------

# Create horizontal stacked bar plot.

# Title graph
# Select data
p_title <- ggplot(dat_scoring[1:4,], aes(x = checklist_ID, y = n)) +
  # Stacked based on score (yes, no, etc.)
  # Set column width
  # Set border colour (black)
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  # Set bar as horizontal
  coord_flip() +
  # Set stacked bar colours and reverse the legend order
  # This is for cosmetic reasons because creating a horizontal graph
  # changes the order data are presented
  scale_fill_manual(values = c("white", "black"), 
                    guide = guide_legend(reverse = T)) +
  # Set the background theme and make all text size 20
  theme_linedraw(base_size = 12) +
  # Chane position of legend and remove legend title
  theme(legend.position = "bottom", legend.title = element_blank()) +
  # Set X scale (actually appears in Y axis position because it's flipped) 
  # using defined labels
  scale_x_discrete(labels = c("Identify that the report contains animal data in title (preclinical, 
                              \nin vivo or synonym)",
                              "Identify the report as systematic review in title")) +
  # Set Y and X lab (again, reversed position!)
  ylab("Number of publications") +
  xlab(element_blank()) +
  theme(plot.caption = element_text(hjust = 0)) +
  scale_y_continuous(breaks=seq(0, 13, 1))

# Introduction graph
p_intro <- ggplot(dat_scoring[5:8,], aes(x = checklist_ID, y = n)) +
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c("grey", "white", "black"), 
                    guide = guide_legend(reverse = T)) +
  theme_linedraw(base_size = 12) +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  scale_x_discrete(labels = c("Provide an explicit statement of the question(s) the review addresses 
                              \n(specify the main objectives of the review, ideally in PICO format)",
                              "Describe the biological rationale for testing the intervention (e.g. 
                              \nhow would the intervention affect the condition)",
                              "Describe the human condition being modelled (e.g. describe what is 
                              \nalready known)")) +
  ylab("Number of publications") +
  xlab(element_blank()) +
  theme(plot.caption = element_text(hjust = 0)) +
  scale_y_continuous(breaks=seq(0, 13, 1))

# Methods graph
p_methods <- ggplot(dat_scoring[9:65,], aes(x = checklist_ID, y = n)) +
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c("grey", "white", "black"), 
                    guide = guide_legend(reverse = T)) +
  theme_linedraw(base_size = 12) +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  scale_x_discrete(labels = c("Describe methods for sub-group and sensitivity analysis",
                              "Describe methods for handling effect sizes over multiple time points
\n(e.g. used all time points or latest time point)",
"Describe methods for assessing heterogeneity between individual
\nstudies",
"Describe methods for handling shared control groups (common issue in
\nanalysis of preclinical studies)",
"Describe methods for any data transformation needed to make extracted
\ndata suitable for analysis (e.g. only sample size range)",
"Describe methods for synthesizing the quantitative effect measures of 
\nincluded studies (e.g. risk ratio, mean difference)",
"Describe methods for assessing publication bias of included studies",
"Describe methods to assess construct validity in individual studies",
"Describe methods and tool used to measure study quality/risk of bias
\nin individual studies (e.g. SYRCLE tool, CAMARADES tool)",
"Report number of independent reviewers extracting data",
"Report the platform and tools used to extract numerical data
\n(Graph2data, Engauge)",
"Describe methods for extracting numerical data from reports (e.g. 
\ndata in bar graph, or non-text presentation)",
"State the number of independent screeners",
"Report the platform used to screen and select studies (Excel,
\nAccess, DistillerSR, SyRF)",
"Describe the study screening/selection process",
"Describe inclusion limits (years conducted, language, AND
\npublication type)",
"Indicate where a full search strategy of all data bases OR
\nrepresentative search strategy can be accessed",
"Eligibility criteria: Describe the timing (prevention vs rescue)
\nof intervention",
"Eligibility criteria: Describe the primary outcomes of interest
\n(what is being measured/assessed in primary studies)",
"Eligibility criteria: Describe the comparators and/or control
\npopulation",
"Eligibility criteria: Describe the intervention/exposure of
\ninterest",
"Eligibility criteria: Describe the animal model to be included
\nin the review (methods of disease induction, age, sex, etc.)",
"Eligibility criteria: Describe the animal species to be included
\nin the review (e.g. only mice, vertebrates, large animals)",
"Indicate any deviations from the protocol OR that there were no
\ndeviations",
"Where can the protocol be accessed and indicate the name of the 
\nprotocol registry OR state that it is not available",
"Indicate whether a review protocol was registered a priori")) +
  ylab("Number of publications") +
  xlab(element_blank()) +
  theme(plot.caption = element_text(hjust = 0)) +
  scale_y_continuous(breaks=seq(0, 13, 1))

# Results graph
p_results <- ggplot(dat_scoring[66:100,], aes(x = checklist_ID, y = n)) +
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c("grey", "white", "black"), 
                    guide = guide_legend(reverse = T)) +
  theme_linedraw(base_size = 12) +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  scale_x_discrete(labels = c("Report the results of publication bias, OR report that it
\nwas not possible/done",
"Report the results of sub-group and sensitivity analysis",
"Report any measure of heterogeneity between studies",
"Report the confidence intervals of outcomes for the included studies",
"Report the outcome effects of primary studies (forest plot if applicable)",
"Report the risk of bias of the primary studies (individual studies/across
\noutcomes)",
"Study characteristics: Report study design/intention (pharmakinetic,
\nmechanistic, efficacy)",
"Study characteristics: Report intervention/exposure details (timing, dose)",
"Study characteristics: Report a measure of the sample size (e.g. total
\nnumber or mean number of animals)",
"Study characteristics: Report animal model details (e.g. method of
\ndisease induction, age, sex)",
"Study characteristics: Report animal species",
"Include a PRISMA flow diagram (or equivalent) of study selection process",
"Report the number of eligible experiments included in the analysis
\n(eligible animal experiments in individual reports)",
"Provides a list or table of individual studies with data or references",
"Report the number of included reports (individual references/publication)
\nincluded in the review")) +
  ylab("Number of publications") +
  xlab(element_blank()) +
  theme(plot.caption = element_text(hjust = 0)) +
  scale_y_continuous(breaks=seq(0, 13, 1))

# Discussion graph
p_discussion <- ggplot(dat_scoring[101:107,], aes(x = checklist_ID, y = n)) +
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c("grey", "white", "black"), 
                    guide = guide_legend(reverse = T)) +
  theme_linedraw(base_size = 12) +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  scale_x_discrete(labels = c("Discuss the limitations of the systematic review)",
                              "Discuss the limitations (i.e. limitation of primary studies
                              \nand/or outcomes included)",
                              "Discuss the impact of the risk of bias of the primary studies")) +
  ylab("Number of publications") +
  xlab(element_blank()) +
  theme(plot.caption = element_text(hjust = 0)) +
  scale_y_continuous(breaks=seq(0, 13, 1))

# Other graph
p_other <- ggplot(dat_scoring[108:113,], aes(x = checklist_ID, y = n)) +
  geom_col(aes(fill = score), width = 0.5, color = "black") +
  coord_flip() +
  scale_fill_manual(values = c("white", "black"), 
                    guide = guide_legend(reverse = T)) +
  theme_linedraw(base_size = 12) +
  theme(legend.position = "bottom", legend.title = element_blank()) +
  scale_x_discrete(labels = c("Report any data sharing, OR that there was no data sharing",
                              "Include the funding source(s) of the systematic review")) +
  ylab("Number of publications") +
  xlab(element_blank()) +
  theme(plot.caption = element_text(hjust = 0)) +
  scale_y_continuous(breaks=seq(0, 13, 1))

# Save Graphs ------------------------------------------------------------------

# Ensure the width is long enough for all graphics and text

ggsave("figures/visualisation_scoring_title.png", plot = p_title, width = 280, height = 100, units = "mm")
ggsave("figures/visualisation_scoring_intro.png", plot = p_intro, width = 280, height = 100, units = "mm")
ggsave("figures/visualisation_scoring_methods.png", plot = p_methods, width = 280, height = 400, units = "mm")
ggsave("figures/visualisation_scoring_results.png", plot = p_results, width = 280, height = 300, units = "mm")
ggsave("figures/visualisation_scoring_discussion.png", plot = p_discussion, width = 280, height = 100, units = "mm")
ggsave("figures/visualisation_scoring_other.png", plot = p_other, width = 280, height = 100, units = "mm")


# Transform Data (PROSPERO) ----------------------------------------------------

# Filter included registrations
dat_prospero <- dat_prospero %>%
  filter(Final_Decision == "include") %>%
  # Select relevant columns
  select(PROSPERO_ID, Status, Anticipated_Start_Date, 
         Anticipated_End_Date, Journal_Submission_Date, Notes) %>%
  # Change date format
  mutate(Anticipated_Start_Date = as.Date(Anticipated_Start_Date, format = "%d/%m/%Y"),
         Anticipated_End_Date = as.Date(Anticipated_End_Date, format = "%d/%m/%Y"),
         Journal_Submission_Date = as.Date(Journal_Submission_Date, format = "%d/%m/%Y")) %>%
  # Create time elapsed column
  mutate(Days_Elapsed = ifelse(Status == "Published", 
                               Journal_Submission_Date - Anticipated_Start_Date, 
                               Sys.Date() - Anticipated_Start_Date),
         Days_Anticipated = Anticipated_End_Date - Anticipated_Start_Date)

# Remove days from time anticipated
dat_prospero$Days_Anticipated <- as.integer(dat_prospero$Days_Anticipated)

# Rename columns
dat_prospero <- dat_prospero %>%
  select("PROSPERO ID" = PROSPERO_ID, "Anticipated Start Date" = Anticipated_Start_Date,
         "Anticipated End Date" = Anticipated_End_Date, 
         "Journal Submission Date (If Published)" = Journal_Submission_Date,
         "Days Elapsed" = Days_Elapsed, "Days Anticipated" = Days_Anticipated) %>%
  # Arrange by date
  arrange("Anticipated Start Date")

# Replace NA with blanks
dat_prospero$`Journal Submission Date (If Published)` <- as.character(
  dat_prospero$`Journal Submission Date (If Published)`)
dat_prospero[is.na(dat_prospero)] <- ""

# Add asterisk for published
dat_prospero$`PROSPERO ID` <- gsub("CRD42020191070", "CRD42020191070\\*", dat_prospero$`PROSPERO ID`)
dat_prospero$`PROSPERO ID` <- gsub("CRD42022306558", "CRD42022306558\\*", dat_prospero$`PROSPERO ID`)

# Add 2 asterisk for conference abstract
dat_prospero$`PROSPERO ID` <- gsub("CRD42021226299", "CRD42021226299\\*\\*", dat_prospero$`PROSPERO ID`)

# Add 3 asterisk for anticipated end date not yet past
dat_prospero$`PROSPERO ID` <- gsub("CRD42023392578", "CRD42023392578\\*\\*\\*", dat_prospero$`PROSPERO ID`)
dat_prospero$`PROSPERO ID` <- gsub("CRD42023425261", "CRD42023425261\\*\\*\\*", dat_prospero$`PROSPERO ID`)

# Create Summary Table ---------------------------------------------------------

# Generate summary table
formattable(dat_prospero, 
            align = c("l", "l", "l", "l", "l", "l", "l", "l"))

# Summary table exported from RStudio and saved as a PNG.
