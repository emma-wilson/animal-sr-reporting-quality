# Review evaluating the reporting quality of systematic reviews describing animal studies of neurodevelopmental conditions: a Registered Report

This data and code accompanies the paper "Review evaluating the reporting quality of systematic reviews describing animal studies of neurodevelopmental conditions: a Registered Report".

## Code
The code is designed to run in R version 4.2.1 (released 2022-06-23). `analysis.R` contains the code to rerun data transformations and create visualisations (output in `figures`).

## Data
All data are contained in the `data` folder and are provided as CSV files.

`review_screening_data.csv`

Contains bibliographic information and screening decisions for each record screened in the main review. Column names:
- StudyId: unique ID given to each record in SyRF
- Title: the title of each record
- Authors: the authors on each record
- PublicationName: the journal where the record is published
- Year: the year the record was published
- Doi: the DOI of the record
- InvestigatorIds: screening decisions of each investigator, separated by a semicolon
- ScreeningDecisions: whether each record was included or excluded

`review_data clean.csv`

Contains annotations given to each included record in the main review. Column names:
- SYRF_ID: unique ID given to each record in SyRF Matches with StudyId in "review_screening_data.csv"
- Title: the title of each record
- Author: the first author surname on each record
- Journal: the journal where each record is published
- Year: the year the record was published
- DOI: the DOI of the record
- Characteristics_PublicationType: the publication type of each record
- Characteristics_ReviewType: whether the record is a systematic review only or SR + MA
- Characteristics_ReviewAim: the coded review aim
- Characteristics_StudyPopulations: whether only animal studies were included, or animal and clinical
- Characteristics_GeneModels: the gene symbols for relevant genetic models included in the reivew
- Characteristics_NTotalStudies: the total number of studies included in the review
- Charactertistics_NAnimalStudies: the number of animal studies included in the review
- Title_SR: whether the review reported it was an SR in the title
- Title_Animal: whether the review reported it was an SR of animal data in the title
- Intro_ConditionModelled: whether the review described the human condition being modelled
- Intro_InterventionRationale: whether the biological rationale for testing the intervention was described
- Intro_ReviewQuestion: whether the review provided an explicit statement of the question(s) the review addresses
- Methods_Protocol: whether the review indicates a priori registration
- Methods_Protocol_Access: whether the protocol can be accessed
- Methods_Protocol_Deviations: whether the review indicates any deviations to the protocol or that there were none
- Methods_SpeciesEligibility: whether species eligibility criteria are described
- Methods_ModelEligibility: whether model eligibility criteria are described
- Methods_InterventionEligibility: whether intervention eligibility criteria are described
- Methods_ControlEligibility: whether control eligibility criteria are described
- Methods_OutcomeEligibility: whether outcome eligibility criteria are described
- Methods_InterventionTimingEligbility: whether intervention timing eligibility criteria are described
- Methods_FullSearch: whether the review indicates where a full search strategy can be found
- Methods_InclusionLimits: whether inclusion limits are described
- Methods_ScreeningProcess: whether the screening process is described
- Methods_ScreeningProcess_Platfor: whether the platformed used for screening is described
- Methods_NumberScreeners: wheher the number of screeners is described
- Methods_DataExtrationProcess: whether the data extraction process is described
- Methods_DataExtractionProcess_Platform: whether the platform for numerical data extraction is described
- Methods_NumberReviewers: whether the number of reviewers is described
- Methods_RobTool: whether the process of risk of bias assessment is described
- Methods_ConstructValidaity: whether the process of assessing construct validity is described
- Methods_PublicationBias: whether the process of assessing publication bias is described
- Methods_SynthesisingEffects: whether the methods used to synthesise effect measures is described
- Methods_DataTransforations: whether methods for data transformations are described
- Methods_SharedControls: whether methods for accounting for shared controls are described
- Methods_Heterogeneity: wheher methods for assessing hetergeneity are described
- Methods_MultipleTimePoints: whether methods for handling effect sizes over multiple time points are decribed
- Methods_SubGroupAnalysis: whether methods for sub group analysis are described
- Results_NumberIncluded: wheher the number of studies inluded is reported
- Results_NumberIncluded_Table: whether the review provides a list of table of all included studies
- Results_NumberIncludedExperiments: whether the review provides a list of eligibile experiments in the analysis
- Results_PRISAFlow: whether a PRISMA flow diagram is included
- Results_SpeciesCharacteristics: whether animal species are reported
- Results_ModelCharacteristics: whether model characteristics are reported
- Results_SampleSizeCharacteristics: whether sample sizes are reported
- Results_InterventionCharacteritics: whether intervention characteristics are reported
- Results_StudyDesignCharactertistics: whether study design characteristics are reported
- Results_RoB: whether results from risk of bias assessments are reported
- Results_OutcomeEffects: whether outcome effects are reported
- Results_ConfidenceIntervals: whether confidence intervals for outcome effects are reported
- Results_Hetergeneity: whether measures of heterogeneity between studies are reported
- Results_SubGroup: wheher results from subgroup analyses are reported
- Results_PublicationBias: whether results from assessments of publication bias are reported
- Discussion_RoB: whether the impact of risk of ibas is discussed
- Discussion_StudyLimitations: whether the limitations of included studies are discussed
- Discussion_ReviewLimitations: whether the limitations of the review itself are discussed
- Other_Funding: whether funding sources are describe
- Other_DataSharing: whether data sharing is rpeorted, or it is reported that there was no data sharing

`Column_labels.csv`

Data to help create short labels for PRISMA-Pre checklist items. 
- checklistID: the PRISA-Pre checklist number for each item
- Label_Short: the short version of each item label. Corresponds with "review_data_clean.csv"
- Label_Long: the long version of eahc item label
- Answer_Options: the available answer options for each item (e.g. Yes, No, Not applicable)
- NA-Meaning: the meaning of NA for each item. NA in this colun means there are no NAS associated with that item

`prospero_data.csv`

Contains data from all PROSPERO registrations screened.
- PROSPERO_ID: the unique PROSPERO ID for each record
- Screener_1: the screening decision from screener 1
- Screener_2: the screening decision from screener 2
- Reconciliation: whether the screening decisions had to be reconciled
- Final_Decision: the final screening decision for each record
- URL: the URL to the PROSPERO record
- Status: whether the review was ongoing or complete. For reviews included by screening only
- Registration_Data: the date the review was registered. DD/MM/YYYY. For reviews included by screening only
- Anticipated_Start_Date: the date the review was anticipated to begin on. DD/MM/YYYY. For reviews included by screening only
- Anticipated_End_Date: the date the review was anticipated to end on. DD/MM/YYYY. For reviews included by screening only
- Journal_Submission_Date: the date of journal submission. For reviews included by screening only where the review is complete
- Notes: any relevant notes

## Figures
All figures are provided in the `figures` folder and are generated from `analysis.R`.

  
