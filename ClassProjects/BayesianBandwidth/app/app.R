#Calvin Guan
#MA 578 Final Project New Codes
### Visualize Shiny

### libraries
library(plotly)
library(plyr)
library(magrittr)
library(shiny)
library(rsconnect)

### functions

#Substract to years
A.sub <- function(var, yr, data = A2){
  var[data$year %in% yr]/(data$won[data$year %in% yr]+ data$lost[data$year %in% yr])
}

#Bayesian Posterior Smoothing Parameter
h.bayes <- function(x,X,a,b){
  l <- length(x); R <- numeric(l)
  for (i in 1:l){
    R[i] <- (gamma(a)/(gamma(a+.5)*sqrt(2*b)))*sum((1/(b*(X-x[i])^2+2))^a)/sum((1/(b*(X-x[i])^2+2))^(a+.5))
  } ; R
}

#Kernel Density Estimation using Bayesian Bandwidth and Gaussian Kernel
KDE <- function(x,h,X){
  n <- length(X); l <- length(x); R <- numeric(l)
  for (i in 1:l){
    R[i] <- sum(dnorm((X-x[i])/h[i]))/(n*h[i])
  } ; R
}

### Import Data

A0 <- read.csv("team_season.txt", header = 1)
A1 <- A0[A0$leag=='N',] ; A1[A1==0] <- NA
A2 <- A1[,c(2,4:18,34:36)]

### Shiny App Codes
# x.start <- 60
# x.end <- 140
# 
# x <- seq(x.start,x.end,.1)

# ---- UI ----
ui <- fluidPage(
  titlePanel("Effect of α & β on Kernel Density Estimation (KDE)"),
  
  sidebarLayout(
    sidebarPanel(
      # Input: Prior alpha0 (shape)
      numericInput("alpha", "α (shape):", 
                   value = 1, min = 0.1, max = 5, step = 0.1),
      sliderInput("alpha_slider", NULL,
                  min = 0.1, max = 5, value = 1, step = 0.1),
      
      # Input: Prior beta0 (scale)
      numericInput("beta", "β (scale):",
                   value = 1, min = 0.1, max = 5, step = 0.1),
      sliderInput("beta_slider", NULL,
                  min = 0.1, max = 5, value = 1, step = 0.1),
      
      # Input: Start year
      selectInput("startyr", "Starting Year", choices = 1946:2004, selected= 1956),
      
      # Input: End year
      selectInput("endyr", "Ending Year", choices = 1946:2004, selected = 1965)
    ),
    
    mainPanel(
      h3("Distribution of NBA teams PPG in a given date range "),
      plotlyOutput("KDEplot"),
      
      h3("Bayesian Posterior Bandwidth (h)"),
      plotlyOutput("BPBplot") 
    )
  )
)


# ---- Server Logic ----
server <- function(input, output, session) {
  
  # Keep slider and numeric input synced for alpha0
  observeEvent(input$alpha, {
    updateSliderInput(session, "alpha_slider", value = input$alpha)
  })
  observeEvent(input$alpha_slider, {
    updateNumericInput(session, "alpha", value = input$alpha_slider)
  })
  
  # Sync beta0 slider and input
  observeEvent(input$beta, {
    updateSliderInput(session, "beta_slider", value = input$beta)
  })
  observeEvent(input$beta_slider, {
    updateNumericInput(session, "beta", value = input$beta_slider)
  })
  
  observe({
    updateSelectInput(session, "endyr",
                      choices = input$startyr:2004,
                      selected = input$endyr)
  })
  
  # Update X based on start/end year input
  X <- reactive({
    A.sub(A2$o_pts, input$startyr:input$endyr)
  })
  
  X.min <- reactive({
    floor(min(X()))
  })
  
  X.max <- reactive({
    ceiling(max(X()))
  })
  
  # x.seq <- reactive({
  #   seq(X.min(),X.max(), .1)
  # })

  
  # Output1: Compute and display posterior mean
  output$KDEplot <- renderPlotly({
    x.vals <- seq(X.min(),X.max(), .1)
    X.vals <- X()
    alpha <- input$alpha
    beta <- input$beta
    h.post <- h.bayes(x.vals, X.vals, alpha, beta)
    density_vals <- KDE(x.vals, h.post, X.vals)
    
  plot_ly() %>%
    add_lines(x = x.vals, y = density_vals, type = 'scatter', mode = 'lines', name = "KDE Curve") %>%
    add_histogram(x = X.vals, xbins = list(start = X.min(), end = X.max(), size = 2), 
                  histnorm = "probability density", name = "Histogram", marker = list(color = "pink")) %>%
    layout(title = "",
      xaxis = list(title = "Teams PPG", dtick = 10), yaxis = list(title = "Density"), bargap = 0.1  
    )
  })
  
  # Output2: Plot the posterior bandwidth
  output$BPBplot <- renderPlotly({
    x.vals <- seq(X.min(),X.max(), .1)
    X.vals <- X()
    alpha <- input$alpha
    beta <- input$beta
    h.post <- h.bayes(x.vals, X(), alpha, beta)
    
    plot_ly() %>%
      add_lines(x = x.vals, y = h.post, type = 'scatter', mode = 'lines', name = "Bayesian Posterior Bandwidth") %>%
      layout(
        xaxis = list(title = "Teams PPG", dtick = 10), yaxis = list(title = "Bandwidth"))
  })
}

# ---- Launch App ----
shinyApp(ui = ui, server = server)

# ---- Deploy App ----
#rsconnect::deployApp(appName = 'Bayesian-KDE-ab-Slider')
