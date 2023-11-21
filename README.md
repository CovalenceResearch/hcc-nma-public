# HCC-NMA

## Background

Primary liver cancer is one of the most common types of cancer, and hepatocellular carcinoma (HCC) is the dominant histology of primary liver cancer.

Treatment options for HCC differ by disease stage. Early and intermediate disease can often be treated curatively using resection or ablation. More advanced disease, e.g., if a patient is diagnosed (too) late, is not usually amenable to curative treatment and requires locoregional or systemic therapy instead. Important locoregional treatment options include transarterial chemoembolization and selective internal radiation therapy (SIRT). Systemic therapies were for years limited to lenvatinib and sorafenib.

In 2021, results of the IMbrave150 trial demonstrated that the combination of atezolizumab and bevacizumab was superior to sorafenib, and atezo-bev has since become the standard of care. Also in 2021, but before IMbrave150 results became available, we published a [systematic literature review and Bayesian network meta-analysis](https://pubmed.ncbi.nlm.nih.gov/33131346/) (NMA) of randomized controlled trials (RCTs) for one SIRT technology, SIR-Spheres Y-90 resin microspheres, relative to sorafenib and lenvatinib, in patients not eligible for TACE. 
As the analysis did not include results for what is now the standard of HCC care, we decided to provide an update of the analysis in the form of a Shiny app. We also took the opportunity to automate subgroup analyses, so users could run a Bayesian NMA on subgroups of interest without having to worry about the technical specification and implementation of a model.

## How it works

The app contains mortality hazard ratios (HRs) for demographic and clinical subgroups such as age, sex, Barcelona Clinic Liver Cancer (BCLC) stage, and Child-Pugh score. These HRs are laid out for each of the four included trials (SARAH and SIRveNIB, comparing Y-90 resin microspheres with sorafenib; REFLECT, comparing lenvatinib with sorafenib; IMbrave150, comparing atezo-bev with sorafenib). Users can choose subgroups of interest for each trial using radio buttons.

Based on the subgroup selection, the model builds a network for analysis, relying on the [gemtc](https://cran.r-project.org/web/packages/gemtc/) package. Specifically, a Bayesian Markov Chain Monte Carlo sampler is implemented, with a normal identity link model and half-normal priors.

Results from the NMA are displayed as a forest plot for atezo-bev, lenvatinib, and Y-90 resin microspheres relative to sorafenib. In addition, rank probabilities for each treatments are displayed in the app, as are Gelman-Rubin-Brooks plots to assess model convergence.