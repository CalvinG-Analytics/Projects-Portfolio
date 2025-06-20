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
A.sub <- function(var,yr){
  var[A2$year %in% yr]/(A2$won[A2$year %in% yr]+ A2$lost[A2$year %in% yr])
}

#Bayesian Posterior Smoothing Parameter
h.bayes <- function(x,X,a,b){
  l <- length(x); R <- numeric(l)
  for (i in 1:l){
    R[i] <- (gamma(a)/(gamma(a+.5)*sqrt(2*b)))*sum((1/(b*(X-x[i])^2+2))^a)/sum((1/(b*(X-x[i])^2+2))^(a+.5))
  } ; R
}

#Kernel Density Estimation using Bayesian Bandwidth and Gausian Kernel
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

###########################################
### Group Data By Decades

g1 <- A.sub(A2$o_pts,1946:1955)
g2 <- A.sub(A2$o_pts,1956:1965)
g3 <- A.sub(A2$o_pts,1966:1975)
g4 <- A.sub(A2$o_pts,1976:1985)
g5 <- A.sub(A2$o_pts,1986:1995)
g6 <- A.sub(A2$o_pts,1996:2005)


### Shiny App Codes
x <- seq(80,140,.1)
X <- g2

# ---- UI ----
ui <- fluidPage(
  titlePanel("Effect of α & β on Kernel Density Estimation (KDE)"),
  
  sidebarLayout(
    sidebarPanel(
      # Input: Prior alpha0 (shape)
      numericInput("alpha", "α (shape):", 
                   value = 2, min = 0.51, max = 10, step = 0.1),
      sliderInput("alpha_slider", NULL,
                  min = 0.51, max = 10, value = 2, step = 0.1),
      
      # Input: Prior beta0 (scale)
      numericInput("beta", "β (scale):",
                   value = 2, min = 0.1, max = 20, step = 0.5),
      sliderInput("beta_slider", NULL,
                  min = 0.1, max = 20, value = 2, step = 0.5)
    ),
    
    mainPanel(
      h3("KDE of NBA teams PPG, 1956 - 1965 "),
      plotlyOutput("KDEplot") 
    )
  )
)


# ---- Server Logic ----
server <- function(input, output, session) {
  
  # Keep slider and numericInput synced for alpha0
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
  
  # Output: Compute and display posterior mean
  output$KDEplot <- renderPlotly({
    x.vals <- x
    
    alpha <- input$alpha
    beta <- input$beta
    h.post <- h.bayes(x.vals, X, alpha, beta)
    density_vals <- KDE(x.vals, h.post, X)
    
  plot_ly(x = x.vals, y = density_vals, type = 'scatter', mode = 'lines') %>%
      layout(
        title = "",
        xaxis = list(title = "Teams PPG"),
        yaxis = list(title = "Density")
      ) 
  })
}

# ---- Launch App ----
shinyApp(ui = ui, server = server)

# ---- Deploy App ----
#rsconnect::deployApp(appName = 'Bayesian-KDE-ab-Slider')
