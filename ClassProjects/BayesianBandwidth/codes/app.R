#Calvin Guan
#MA 578 Final Project New Codes
### Visualize Shiny

### libraries
library(here)
library(shiny)
library(rsconnect)

#setwd(here::here("ClassProjects\\BayesianBandwidth\\codes"))
source(here::here("LibFuncs.R"))
source(here::here("Import.R"))

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
                   value = 2, min = 0.51, max = 20, step = 0.1),
      sliderInput("alpha_slider", NULL,
                  min = 0.51, max = 20, value = 2, step = 0.1),
      
      # Input: Prior beta0 (scale)
      numericInput("beta", "β (scale):",
                   value = 5, min = 0.1, max = 50, step = 0.5),
      sliderInput("beta_slider", NULL,
                  min = 0.1, max = 50, value = 5, step = 0.5)
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
#shinyApp(ui = ui, server = server)

# ---- Deploy App ----
rsconnect::deployApp(appName = 'Bayesian-KDE-ab-Slider')
