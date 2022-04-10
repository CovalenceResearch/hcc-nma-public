library(shiny)
library(shinyWidgets)

# Define UI
shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  titlePanel("Unresectable HCC Subgroup Network Meta-Analysis Automation"),
  fluidRow(
    column(
      2,
      wellPanel(
        radioButtons("SARAH", "SARAH (per protocol)",
          choiceNames = list(
            HTML("<span>Age</span><span>&leq; 65</span><span>1.08 (0.78&ndash;1.49)</span>"),
            HTML("<span>Age</span><span>&gt; 65</span><span>0.89 (0.65&ndash;1.23)</span>"),
            HTML("<span>Sex</span><span>M</span><span>1.04 (0.82&ndash;1.31)</span>"),
            HTML("<span>Sex</span><span>F</span><span>0.62 (0.29&ndash;1.31)</span>"),
            HTML("<span>ECOG</span><span>0</span><span>1.17 (0.87&ndash;1.56)</span>"),
            HTML("<span>ECOG</span><span>1</span><span>0.75 (0.52&ndash;1.07)</span>"),
            HTML("<span>Cirrhosis</span><span>No</span><span>1.12 (0.52&ndash;2.40)</span>"),
            HTML("<span>Cirrhosis</span><span>Yes</span><span>0.98 (0.77&ndash;1.24)</span>"),
            HTML("<span>BCLC</span><span>A+B</span><span>0.89 (0.59&ndash;1.33)</span>"),
            HTML("<span>BCLC</span><span>C</span><span>1.06 (0.81&ndash;1.39)</span>"),
            HTML("<span>Child-Pugh</span><span>A</span><span>1.01 (0.79&ndash;1.29)</span>"),
            HTML("<span>Child-Pugh</span><span>B</span><span>0.88 (0.48&ndash;1.62)</span>"),
            HTML("<span>Involvement</span><span>Unilobar</span><span>0.99 (0.77&ndash;1.28)</span>"),
            HTML("<span>Involvement</span><span>Bilobar</span><span>0.95 (0.57&ndash;1.58)</span>"),
            HTML("<span>Type</span><span>Nodular</span><span>0.97 (0.71&ndash;1.34)</span>"),
            HTML("<span>Type</span><span>Infiltrative</span><span>1.04 (0.74&ndash;1.45)</span>"),
            HTML("<span>Number</span><span>Single</span><span>1.02 (0.73&ndash;1.43)</span>"),
            HTML("<span>Number</span><span>Multiple</span><span>0.96 (0.71&ndash;1.30)</span>"),
            HTML("<span>Burden</span><span>&leq; 25%</span><span>0.97 (0.74&ndash;1.28)</span>"),
            HTML("<span>Burden</span><span>&gt; 25%</span><span>1.12 (0.75&ndash;1.67)</span>"),
            HTML("<span>MVI</span><span>No</span><span>0.95 (0.65&ndash;1.37)</span>"),
            HTML("<span>MVI</span><span>Yes</span><span>1.02 (0.77&ndash;1.36)</span>"),
            HTML("<span>PVI</span><span>Main</span><span>1.18 (0.70&ndash;1.98)</span>"),
            HTML("<span>PVI</span><span>Other</span><span>1.06 (0.74&ndash;1.52)</span>"),
            HTML("<span>Occlusion</span><span>Complete</span><span>2.44 (1.01&ndash;5.88)</span>"),
            HTML("<span>Occlusion</span><span>Incomplete</span><span>0.78 (0.39&ndash;1.55)</span>"),
            HTML("<span>TACE failure</span><span>No</span><span>1.13 (0.83&ndash;1.54)</span>"),
            HTML("<span>TACE failure</span><span>Yes</span><span>0.86 (0.62&ndash;1.20)</span>"),
            HTML("<span>AFP</span><span>&leq; 400</span><span>1.07 (0.80&ndash;1.43)</span>"),
            HTML("<span>AFP</span><span>&gt; 400</span><span>0.79 (0.53&ndash;1.18)</span>")
          ),
          choiceValues = c(
            "age_lte65",
            "age_gt65",
            "sex_male",
            "sex_female",
            "ecog_0",
            "ecog_1",
            "cirrhosis_y",
            "cirrhosis_n",
            "bclc_nonC",
            "bclc_C",
            "cp_a",
            "cp_b",
            "involvement_uni",
            "involvement_bi",
            "type_nodular",
            "type_infiltrative",
            "number_single",
            "number_multiple",
            "burden_lte25",
            "burden_gt25",
            "mvi_n",
            "mvi_y",
            "pvi_main",
            "pvi_other",
            "occlusion_complete",
            "occlusion_incomplete",
            "tacefailure_n",
            "tacefailure_y",
            "afp_lte400",
            "afp_gt400"
          )
        )
      )
    ),
    column(
      2,
      wellPanel(
        radioButtons("SIRveNIB", "SIRveNIB (per protocol)",
          choiceNames = list(
            HTML("<span>ECOG</span><span>0</span><span>0.58 (0.3&ndash;1.0)</span>"),
            HTML("<span>ECOG</span><span>1</span><span>0.95 (0.7&ndash;1.3)</span>"),
            HTML("<span>BCLC</span><span>B</span><span>1.01 (0.7&ndash;1.5)</span>"),
            HTML("<span>BCLC</span><span>C</span><span>0.67 (0.4&ndash;1.0)</span>"),
            HTML("<span>Child-Pugh</span><span>A</span><span>0.84 (0.6&ndash;1.1)</span>"),
            HTML("<span>Child-Pugh</span><span>B</span><span>1.14 (0.5&ndash;2.7)</span>"),
            HTML("<span>PVT</span><span>Yes</span><span>0.73 (0.4&ndash;1.2)</span>"),
            HTML("<span>PVT</span><span>No</span><span>0.93 (0.7&ndash;1.3)</span>"),
            HTML("<span>TACE failure</span><span>No</span><span>0.76 (0.6&ndash;1.0)</span>"),
            HTML("<span>Prior Rx</span><span>Yes</span><span>1.18 (0.7&ndash;2.0)</span>"),
            HTML("<span>Prior Rx</span><span>No</span><span>0.78 (0.6&ndash;1.1)</span>"),
            HTML("<span>Hepatitis</span><span>B</span><span>0.74 (0.5&ndash;1.1)</span>"),
            HTML("<span>Hepatitis</span><span>C</span><span>1.61 (0.8&ndash;3.3)</span>"),
            HTML("<span>ALBI</span><span>1</span><span>0.80 (0.5&ndash;1.3)</span>"),
            HTML("<span>ALBI</span><span>2/3</span><span>0.89 (0.6&ndash;1.2)</span>")
          ),
          choiceValues = c(
            "ecog_0",
            "ecog_1",
            "bclc_nonC",
            "bclc_C",
            "cp_a",
            "cp_b",
            "pvt_y",
            "pvt_n",
            "tacefailure_n",
            "priorrx_y",
            "priorrx_n",
            "hepatitis_b",
            "hepatitis_c",
            "albi_1",
            "albi_23"
          )
        )
      )
    ),
    column(
      2,
      wellPanel(
        radioButtons("IMbrave150", "IMbrave150 (intent-to-treat)",
          choiceNames = list(
            HTML("<span>Age</span><span>&geq; 65</span><span>0.58 (0.36&ndash;0.92)</span>"),
            HTML("<span>Sex</span><span>M</span><span>0.66 (0.47&ndash;0.92)</span>"),
            HTML("<span>Sex</span><span>F</span><span>0.35 (0.15&ndash;0.81)</span>"),
            HTML("<span>Region</span><span>Asia</span><span>0.53 (0.32&ndash;0.87)</span>"),
            HTML("<span>Region</span><span>RoW</span><span>0.65 (0.44&ndash;0.98)</span>"),
            HTML("<span>ECOG</span><span>0</span><span>0.67 (0.43&ndash;1.06)</span>"),
            HTML("<span>ECOG</span><span>1</span><span>0.51 (0.33&ndash;0.80)</span>"),
            HTML("<span>BCLC</span><span>B</span><span>1.09 (0.33&ndash;3.53)</span>"),
            HTML("<span>BCLC</span><span>C</span><span>0.54 (0.39&ndash;0.75)</span>"),
            HTML("<span>AFP</span><span>&le; 400</span><span>0.52 (0.34&ndash;0.81)</span>"),
            HTML("<span>AFP</span><span>&geq; 400</span><span>0.68 (0.43&ndash;1.08)</span>"),
            HTML("<span>MVI</span><span>No</span><span>0.64 (0.40&ndash;1.02)</span>"),
            HTML("<span>MVI</span><span>Yes</span><span>0.58 (0.38&ndash;0.89)</span>"),
            HTML("<span>EHS</span><span>No</span><span>0.77 (0.43&ndash;1.36)</span>"),
            HTML("<span>EHS</span><span>Yes</span><span>0.50 (0.34&ndash;0.73)</span>"),
            HTML("<span>MVI or EHS</span><span>No</span><span>0.69 (0.29&ndash;1.65)</span>"),
            HTML("<span>MVI or EHS</span><span>Yes</span><span>0.55 (0.39&ndash;0.77)</span>"),
            HTML("<span>Hepatitis</span><span>B</span><span>0.51 (0.32&ndash;0.81)</span>"),
            HTML("<span>Hepatitis</span><span>C</span><span>0.43 (0.22&ndash;0.87)</span>"),
            HTML("<span>Hepatitis</span><span>None</span><span>0.91 (0.52&ndash;1.60)</span>"),
            HTML("<span>Locoregional</span><span>No</span><span>0.57 (0.38&ndash;0.87)</span>"),
            HTML("<span>Locoregional</span><span>Yes</span><span>0.63 (0.39&ndash;1.01)</span>")
          ),
          choiceValues = c(
            "age_gt65",
            "sex_male",
            "sex_female",
            "region_asia",
            "region_row",
            "ecog_0",
            "ecog_1",
            "bclc_nonC",
            "bclc_C",
            "afp_lte400",
            "afp_gt400",
            "mvi_n",
            "mvi_y",
            "ehs_n",
            "ehs_y",
            "mviorehs_n",
            "mviorehs_y",
            "hepatitis_b",
            "hepatitis_c",
            "hepatitis_none",
            "priorlocoregional_n",
            "priorlocoregional_y"
          )
        )
      )
    ),
    column(
      2,
      wellPanel(
        radioButtons("REFLECT", "REFLECT (assumed intent-to-treat)",
          choiceNames = list(
            HTML("<span>Age</span><span>&lt; 65</span><span>0.94 (0.77&ndash;1.15)</span>"),
            HTML("<span>Age</span><span>&geq; 65</span><span>0.84 (0.66&ndash;1.07)</span>"),
            HTML("<span>Sex</span><span>M</span><span>0.91 (0.77&ndash;1.07)</span>"),
            HTML("<span>Sex</span><span>F</span><span>0.84 (0.56&ndash;1.26)</span>"),
            HTML("<span>Region</span><span>APAC</span><span>0.86 (0.72&ndash;1.02)</span>"),
            HTML("<span>Region</span><span>West</span><span>1.08 (0.82&ndash;1.42)</span>"),
            HTML("<span>ECOG</span><span>0</span><span>0.88 (0.73&ndash;1.06)</span>"),
            HTML("<span>ECOG</span><span>1</span><span>0.97 (0.76&ndash;1.25)</span>"),
            HTML("<span>BCLC</span><span>B</span><span>0.91 (0.65&ndash;1.28)</span>"),
            HTML("<span>BCLC</span><span>C</span><span>0.92 (0.77&ndash;1.08)</span>"),
            HTML("<span>AFP</span><span>&lt; 200</span><span>0.91 (0.74&ndash;1.12)</span>"),
            HTML("<span>AFP</span><span>&geq; 200</span><span>0.78 (0.63&ndash;0.98)</span>"),
            HTML("<span>MVI or EHS</span><span>No</span><span>1.05 (0.79&ndash;1.40)</span>"),
            HTML("<span>MVI or EHS</span><span>Yes</span><span>0.87 (0.73&ndash;1.04)</span>"),
            HTML("<span>Hepatitis</span><span>B</span><span>0.83 (0.68&ndash;1.02)</span>"),
            HTML("<span>Hepatitis</span><span>C</span><span>0.91 (0.66&ndash;1.26)</span>"),
            HTML("<span>Etiology</span><span>Alcohol</span><span>1.03 (0.47&ndash;2.28)</span>"),
            HTML("<span>Weight</span><span>&lt; 60kg</span><span>0.85 (0.65&ndash;1.11)</span>"),
            HTML("<span>Weight</span><span>&geq; 60kg</span><span>0.95 (0.79&ndash;1.14)</span>")
          ),
          choiceValues = c(
            "age_lt65",
            "age_geq65",
            "sex_male",
            "sex_female",
            "region_asia",
            "region_row",
            "ecog_0",
            "ecog_1",
            "bclc_nonC",
            "bclc_C",
            "afp_lte200",
            "afp_gt200",
            "mviorehs_n",
            "mviorehs_y",
            "hepatitis_b",
            "hepatitis_c",
            "etiology_alcohol",
            "weight_lt60",
            "weight_geq60"
          )
        )
      )
    ),
    column(
      4,
      # uiOutput("selected"),
      h3("Forest plot"),
      plotOutput("forestPlot", height = "210px"),
      h3("Rank probabilities"),
      plotOutput("rankPlot", height = "350px"),
      h3("Gelman-Rubin-Brooks plots"),
      plotOutput("gelmanRubin", height = "350px"),
    )
  )
))
