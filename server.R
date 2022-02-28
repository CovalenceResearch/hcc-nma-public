#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Installation on fresh Ubuntu
# Add "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" to /etc/apt/sources.list
# Add the key ID for CRAN: sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# Update repo: sudo apt update
# Install base R: sudo apt install r-base
# Install Shiny: sudo su - \ -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\""
# Install gdebi: sudo apt install gdebi-core
# Download Shiny Server: wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb
# Install Shiny Server: sudo gdebi shiny-server-1.5.16.958-amd64.deb
# Check status: sudo systemctl status shiny-server.service

# For JAGS dependent programs, run JAGS and dependencies:
#
# sudo apt-get install jags
# sudo apt-get install libxml2-dev
# sudo apt-get install libglpk-dev
# sudo apt-get install r-cran-rcppeigen
# sudo apt-get install libssl-dev
# sudo apt-get install libcurl4-openssl-dev
#
# Run R, then install.packages("rjags"), install.packages("gemtc"), install.packages("tidyverse"), install.packages("shinyWidgets") etc. etc. as required

# Edit Shiny Server config: sudo pico /etc/shiny-server/shiny-server.conf

library(shiny)

if (!require(gemtc)) {
  install.packages("gemtc")
  library(gemtc)
}

if (!require(tidyverse)) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require(forestplot)) {
  install.packages("forestplot")
  library(forestplot)
}

sarah_data <- read.csv(text = "subgroup,hr,low,high
age_lte65,1.08,0.78,1.49
age_gt65,0.89,0.65,1.23
sex_male,1.04,0.82,1.31
sex_female,0.62,0.29,1.31
ecog_0,1.17,0.87,1.56
ecog_1,0.75,0.52,1.07
cirrhosis_y,1.12,0.52,2.40
cirrhosis_n,0.98,0.77,1.24
bclc_nonC,0.89,0.59,1.33
bclc_C,1.06,0.81,1.39
cp_a,1.01,0.79,1.29
cp_b,0.88,0.48,1.62
involvement_uni,0.99,0.77,1.28
involvement_bi,0.95,0.57,1.58
type_nodular,0.97,0.71,1.34
type_infiltrative,1.04,0.74,1.45
number_single,1.02,0.73,1.43
number_multiple,0.96,0.71,1.30
burden_lte25,0.97,0.74,1.28
burden_gt25,1.12,0.75,1.67
mvi_n,0.95,0.65,1.37
mvi_y,1.02,0.77,1.36
pvi_main,1.18,0.70,1.98
pvi_other,1.06,0.74,1.52
occlusion_complete,2.44,1.01,5.88
occlusion_incomplete,0.78,0.39,1.55
tacefailure_n,1.13,0.83,1.54
tacefailure_y,0.86,0.62,1.20
afp_lte400,1.07,0.80,1.43
afp_gt400,0.79,0.53,1.18")
sirvenib_data <- read.csv(text = "subgroup,hr,low,high
ecog_0,0.58,0.3,1.0
ecog_1,0.95,0.7,1.3
bclc_nonC,1.01,0.7,1.5
bclc_C,0.67,0.4,1.0
cp_a,0.84,0.6,1.1
cp_b,1.14,0.5,2.7
pvt_y,0.73,0.4,1.2
pvt_n,0.93,0.7,1.3
tacefailure_n,0.76,0.6,1.0
priorrx_y,1.18,0.7,2.0
priorrx_n,0.78,0.6,1.1
hepatitis_b,0.74,0.5,1.1
hepatitis_c,1.61,0.8,3.3
albi_1,0.80,0.5,1.3
albi_23,0.89,0.6,1.2")
reflect_data <- read.csv(text = "subgroup,hr,low,high
age_lt65,0.94,0.77,1.15
age_geq65,0.84,0.66,1.07
sex_male,0.91,0.77,1.07
sex_female,0.84,0.56,1.26
region_asia,0.86,0.72,1.02
region_row,1.08,0.82,1.42
ecog_0,0.88,0.73,1.06
ecog_1,0.97,0.76,1.25
bclc_nonC,0.91,0.65,1.28
bclc_C,0.92,0.77,1.08
afp_lte200,0.91,0.74,1.12
afp_gt200,0.78,0.63,0.98
mviorehs_n,1.05,0.79,1.40
mviorehs_y,0.87,0.73,1.04
hepatitis_b,0.83,0.68,1.02
hepatitis_c,0.91,0.66,1.26
etiology_alcohol,1.03,0.47,2.28
weight_lt60,0.85,0.65,1.11
weight_geq600.95,0.79,1.14")
imbrave150_data <- read.csv(text = "subgroup,hr,low,high
age_gt65,0.58,0.36,0.92
sex_male,0.66,0.47,0.92
sex_female,0.35,0.15,0.81
region_asia,0.53,0.32,0.87
region_row,0.65,0.44,0.98
ecog_0,0.67,0.43,1.06
ecog_1,0.51,0.33,0.80
bclc_nonC,1.09,0.33,3.53
bclc_C,0.54,0.39,0.75
afp_lte400,0.52,0.34,0.81
afp_gt400,0.68,0.43,1.08
mvi_n,0.64,0.40,1.02
mvi_y,0.58,0.38,0.89
ehs_n,0.77,0.43,1.36
ehs_y,0.50,0.34,0.73
mviorehs_n,0.69,0.29,1.65
mviorehs_y,0.55,0.39,0.77
hepatitis_b,0.51,0.32,0.81
hepatitis_c,0.43,0.22,0.87
hepatitis_none,0.91,0.52,1.60
priorlocoregional_n,0.57,0.38,0.87
priorlocoregional_y,0.63,0.39,1.01")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  model <- eventReactive(c(input$SARAH, input$SIRveNIB, input$REFLECT, input$IMbrave150), {
    sarah <- paste("1", "2", log((sarah_data %>% filter(subgroup == input$SARAH))$hr), (log((sarah_data %>% filter(subgroup == input$SARAH))$high) - log((sarah_data %>% filter(subgroup == input$SARAH))$low)) / 3.92, "2", sep = "\t")
    sirvenib <- paste("1", "2", log((sirvenib_data %>% filter(subgroup == input$SIRveNIB))$hr), (log((sirvenib_data %>% filter(subgroup == input$SIRveNIB))$high) - log((sirvenib_data %>% filter(subgroup == input$SIRveNIB))$low)) / 3.92, "2", sep = "\t")
    reflect <- paste("1", "3", log((reflect_data %>% filter(subgroup == input$REFLECT))$hr), (log((reflect_data %>% filter(subgroup == input$REFLECT))$high) - log((reflect_data %>% filter(subgroup == input$REFLECT))$low)) / 3.92, "2", sep = "\t")
    imbrave150 <- paste("1", "4", log((imbrave150_data %>% filter(subgroup == input$IMbrave150))$hr), (log((imbrave150_data %>% filter(subgroup == input$IMbrave150))$high) - log((imbrave150_data %>% filter(subgroup == input$IMbrave150))$low)) / 3.92, "2", sep = "\t")

    gemtc_input <- paste("t[,1]	t[,2]	y[,2]	se[,2]	na[]", sarah, sirvenib, reflect, imbrave150, sep = "\n")
    data.src <- read.table(textConnection(gemtc_input), header = TRUE)

    data <- mtc.data.studyrow(data.src,
      armVars = c("treatment" = "t", "diff" = "y", "std.err" = "se"),
      treatmentNames = c("Sorafenib", "SIR_Spheres", "Lenvatinib", "Atezo_Bev")
    )

    network <- mtc.network(data.re = data)

    fe_model <- mtc.model(network, linearModel = "fixed", link = "identity", likelihood = "normal")
    mcmc_fe <- mtc.run(fe_model, n.adapt = 500, n.iter = 5000, thin = 1)

    forest_data <- data.frame(
      name = c("Atezo-Bev", "Lenvatinib", "SIR-Spheres"),
      pe = round(c(exp(relative.effect.table(mcmc_fe))[20], exp(relative.effect.table(mcmc_fe))[24], exp(relative.effect.table(mcmc_fe))[28]), digits = 2),
      ci.l = round(c(exp(relative.effect.table(mcmc_fe))[4], exp(relative.effect.table(mcmc_fe))[8], exp(relative.effect.table(mcmc_fe))[12]), digits = 2),
      ci.u = round(c(exp(relative.effect.table(mcmc_fe))[36], exp(relative.effect.table(mcmc_fe))[40], exp(relative.effect.table(mcmc_fe))[44]), digits = 2)
    )

    forest_data$HRCI <- ifelse(is.na(forest_data$pe), "", paste(format(round(forest_data$pe, 2), nsmall = 2), " (", format(round(forest_data$ci.l, 2), nsmall = 2), "–", format(round(forest_data$ci.u, 2), nsmall = 2), ")", sep = ""))
    plot_data <- cbind(c("Atezo-Bev", "Lenvatinib", "SIR-Spheres"), forest_data$HRCI)

    rankplot_data <- rank.probability(mcmc_fe, preferredDirection = -1)

    list(rankplot_data = rankplot_data, forest_data = forest_data, plot_data = plot_data, mcmc_fe = mcmc_fe)
  })

  output$forestPlot <- renderPlot({
    print(model()$plot_data)
    op <- par(mar = c(0, 0, 0, 0))
    par(op)
    forestplot(model()$plot_data,
      graph.pos = 2,
      mean = c(round(model()$forest_data$pe, digits = 2)),
      lower = c(round(model()$forest_data$ci.l, digits = 2)),
      upper = c(round(model()$forest_data$ci.u, digits = 2)),
      is.summary = c(FALSE, FALSE, FALSE),
      xlab = "Mortality HR (95% CrI) relative to sorafenib",
      fn.ci_sum = c(fpDrawSummaryCI, fpDrawSummaryCI, fpDrawSummaryCI),
      fn.ci_norm = function(size, ...) {
        fpDrawNormalCI(size = size * 2, ...)
      },
      xlog = TRUE,
      mar = unit(c(0, 0, 0, 0), "mm"),
      col = fpColors(box = c("#5BBF21")),
      zero = 1, lineheight = unit(20, "mm"), colgap = unit(4, "mm"),
      lwd.ci = 1, ci.vertices = TRUE, ci.vertices.height = 0.1,
      txt_gp = fpTxtGp(
        label = gpar(cex = 1.2),
        ticks = gpar(cex = 1.2),
        xlab = gpar(cex = 1.2, fontface = "bold")
      )
    )
  })

  output$rankPlot <- renderPlot({
    plot(model()$rankplot_data, beside = TRUE, cex.lab = 1.3, cex.axis = 1.3, cex.main = 1.3, cex.sub = 1.3)
  })

  output$gelmanRubin <- renderPlot({
    gelman.plot(model()$mcmc_fe, cex.lab = 1.5, cex.axis = 1.5, cex.main = 1.5, cex.sub = 1.5)
  })

  output$selected <- renderUI({
    HTML(paste("<strong>SARAH:</strong>", input$SARAH, "<strong>SIRveNIB:</strong>", input$SIRveNIB, "<strong>IMbrave150:</strong>", input$IMbrave150, "<strong>REFLECT:</strong>", input$REFLECT))
  })
})
