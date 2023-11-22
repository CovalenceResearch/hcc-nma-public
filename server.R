library(shiny)
library(gemtc)
library(tidyverse)
library(forestplot)

sarah_data <- read.csv(file = "data/data_sarah.csv")
sirvenib_data <- read.csv(file = "data/data_sirvenib.csv")
reflect_data <- read.csv(file = "data/data_reflect.csv")
imbrave150_data <- read.csv(file = "data/data_imbrave150.csv")

# Define server logic
shinyServer(function(input, output) {
  model <- eventReactive(
    c(
      input$SARAH,
      input$SIRveNIB,
      input$REFLECT,
      input$IMbrave150
    ),
    {
      sarah <- paste("1", "2",
        log((sarah_data %>%
          filter(subgroup == input$SARAH))$hr),
        (log((sarah_data %>%
          filter(subgroup == input$SARAH))$high) -
          log((sarah_data %>%
            filter(subgroup == input$SARAH))$low)) / 3.92,
        "2",
        sep = "\t"
      )

      sirvenib <- paste("1", "2",
        log((sirvenib_data %>%
          filter(subgroup == input$SIRveNIB))$hr),
        (log((sirvenib_data %>%
          filter(subgroup == input$SIRveNIB))$high) -
          log((sirvenib_data %>%
            filter(subgroup == input$SIRveNIB))$low)) /
          3.92, "2",
        sep = "\t"
      )

      reflect <- paste("1", "3",
        log((reflect_data %>%
          filter(subgroup == input$REFLECT))$hr),
        (log((reflect_data %>%
          filter(subgroup == input$REFLECT))$high) -
          log((reflect_data %>%
            filter(subgroup == input$REFLECT))$low)) /
          3.92, "2",
        sep = "\t"
      )

      imbrave150 <- paste("1", "4",
        log((imbrave150_data %>%
          filter(subgroup == input$IMbrave150))$hr),
        (log((imbrave150_data %>%
          filter(subgroup == input$IMbrave150))$high) -
          log((imbrave150_data %>%
            filter(subgroup == input$IMbrave150))$low)) /
          3.92, "2",
        sep = "\t"
      )

      gemtc_input <- paste("t[,1]	t[,2]	y[,2]	se[,2]	na[]",
        sarah,
        sirvenib,
        reflect,
        imbrave150,
        sep = "\n"
      )

      data.src <- read.table(textConnection(gemtc_input), header = TRUE)

      data <- mtc.data.studyrow(data.src,
        armVars = c("treatment" = "t", "diff" = "y", "std.err" = "se"),
        treatmentNames = c("Sorafenib", "SIR_Spheres", "Lenvatinib", "Atezo_Bev")
      )

      network <- mtc.network(data.re = data)

      fe_model <- mtc.model(network,
        linearModel = "fixed",
        link = "identity",
        likelihood = "normal"
      )
      
      mcmc_fe <- mtc.run(fe_model, n.adapt = 500, n.iter = 5000, thin = 1)

      forest_data <- data.frame(
        name = c("Atezo-Bev", "Lenvatinib", "SIR-Spheres"),
        pe = round(c(
          exp(relative.effect.table(mcmc_fe))[20],
          exp(relative.effect.table(mcmc_fe))[24],
          exp(relative.effect.table(mcmc_fe))[28]
        ),
        digits = 2
        ),
        ci.l = round(c(
          exp(relative.effect.table(mcmc_fe))[4],
          exp(relative.effect.table(mcmc_fe))[8],
          exp(relative.effect.table(mcmc_fe))[12]
        ),
        digits = 2
        ),
        ci.u = round(c(
          exp(relative.effect.table(mcmc_fe))[36],
          exp(relative.effect.table(mcmc_fe))[40],
          exp(relative.effect.table(mcmc_fe))[44]
        ),
        digits = 2
        )
      )

      forest_data$HRCI <- ifelse(is.na(forest_data$pe),
        "",
        paste(format(round(forest_data$pe, 2),
          nsmall = 2
        ),
        " (",
        format(round(forest_data$ci.l, 2),
          nsmall = 2
        ), "–",
        format(round(forest_data$ci.u, 2),
          nsmall = 2
        ), ")",
        sep = ""
        )
      )

      plot_data <- cbind(
        c("Atezo-Bev", "Lenvatinib", "SIR-Spheres"),
        forest_data$HRCI
      )

      rankplot_data <- rank.probability(mcmc_fe, preferredDirection = -1)

      list(
        rankplot_data = rankplot_data,
        forest_data = forest_data,
        plot_data = plot_data,
        mcmc_fe = mcmc_fe,
        network = fe_model
      )
    }
  )
  
  output$network <- renderPlot({
    plot(model()$network,
         layout = igraph::layout.circle,
         vertex.label.family = "sans",
         vertex.label.cex = 1.3,
         vertex.size = 20,
         vertex.color = "#2171b5",
         vertex.frame.color = NA,
         vertex.label.dist = 15,
         vertex.label.degree = c(0, 0, pi, 0)
    )
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
      col = fpColors(box = c("#2171b5")),
      zero = 1,
      lineheight = unit(20, "mm"),
      colgap = unit(4, "mm"),
      lwd.ci = 1,
      ci.vertices = TRUE,
      ci.vertices.height = 0.1,
      txt_gp = fpTxtGp(
        label = gpar(cex = 1.2),
        ticks = gpar(cex = 1.2),
        xlab = gpar(cex = 1.2, fontface = "bold")
      )
    )
  })

  output$rankPlot <- renderPlot({
    plot(model()$rankplot_data,
      beside = TRUE,
      cex.lab = 1.3,
      cex.axis = 1.3,
      cex.main = 1.3,
      cex.sub = 1.3,
      col = c("#2171b5", "#6baed6", "#bdd7e7", "#eff3ff")
    )
  })

  output$gelmanRubin <- renderPlot({
    gelman.plot(model()$mcmc_fe,
      cex.lab = 1.5,
      cex.axis = 1.5,
      cex.main = 1.5,
      cex.sub = 1.5,
      col = c("#2171b5", "#6baed6", "#bdd7e7", "#eff3ff")
    )
  })

  output$selected <- renderUI({
    HTML(
      paste(
        "<strong>SARAH:</strong>",
        input$SARAH,
        "<strong>SIRveNIB:</strong>",
        input$SIRveNIB,
        "<strong>IMbrave150:</strong>",
        input$IMbrave150,
        "<strong>REFLECT:</strong>",
        input$REFLECT
      )
    )
  })
})
