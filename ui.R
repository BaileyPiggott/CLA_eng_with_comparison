
# user interface definition
# Engineering CLA data boxplots

library(shiny)

shinyUI(fluidPage(
  
  
  headerPanel("CLA Scores"), 
  
  sidebarPanel(
    selectInput("discipline", "Discipline:",
                c("Mechanical" = 1, 
                  "Electrical" = 2, 
                  "Computer" = 3,
                  "Civil" = 4,
                  "Chemical" = 5,
                  "Engineering Chemistry" = 6,
                  "Mining" = 7,
                  "Geological" = 8,
                  "Engineering Physics" = 9,
                  "Engineering Math" = 10
                )#end options
    ),#end selectInput
    
    downloadButton("downloadPDF", "Download PDF"),
    
    #text description of app ------------------------
    
    br(),br(), 
    h4("About This App"),
    p("This app displays the CLA+ (Collegiate Learning Assessment Plus) scores of engineering students from each 
      of the 10 disciplines. CLA+ employs two types of performance assessments: a performance task and a series 
      of selected-response questions, both of which require students to apply a thought process in order to 
      arrive at a solution to a problem."),
    p("First and second year samples are the same students who wrote the CLA test both years."),
    br(),
    p("Learn more about the HEQCO Learning Outcomes Assessment Project", 
      a("here.", href = "http://www.queensu.ca/qloa/"))
    # end text description 
    
  ),#end sidebar panel
  
  mainPanel(
    plotOutput("claPlot")
  )
  
))
