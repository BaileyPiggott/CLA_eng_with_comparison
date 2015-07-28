
# Engineering CLA data boxplots
#server logic

#this application creates a boxplot of CLA scores for chosen engineering discipline, 
# and compares with scores for all engineering
# also calculates and displays sample sizes for each year for all eng and per discipline


source("set_up.R") # load libraries and set up dataframes for each discipline


shinyServer(function(input, output) {
  
  plotInput <- reactive({
    
    if(input$discipline == 1){
      df = mech
      disc_name = "Mechanical Engineering" # text string for title and legend
    }
    else if(input$discipline == 2){
      df = elec
      disc_name = "Electrical Engineering"
    }
    else if(input$discipline == 3){
      df = cmpe
      disc_name = "Computer Engineering"
      dummy <- dummy_4 %>% mutate(plan = "CMPE")
    } 
    else if(input$discipline == 4){
      df = civl
      disc_name = "Civil Engineering"
    }    
    else if(input$discipline == 5){
      df = chem
      disc_name = "Chemical Engineering"
    } 
    else if(input$discipline == 6){
      df = ench
      disc_name = "Engineering Chemistry"
      dummy <- dummy_4 %>% mutate(plan = "ENCH")
    } 
    else if(input$discipline == 7){
      df = mine
      disc_name = "Mining Engineering"
      dummy <-dummy_4 %>% mutate(plan = "MINE")
    } 
    else if(input$discipline == 8){
      df = geoe
      disc_name = "Geological Engineering"
    } 
    else if(input$discipline == 9){
      df = enph
      disc_name = "Engineering Physics"
      dummy <- bind_rows(dummy_1, dummy_2, dummy_4) %>% mutate(plan = "ENPH")
    } 
    else if (input$discipline == 10){
      df = mthe
      disc_name = "Math and Engineering"
      dummy <- dummy_4 %>% mutate(plan = "MTHE")
    }
    else{
      df = fix # df is row bound to all eng ; don't want data twice and fix is a null data frame
      disc_name = "Engineering"
    }
       
# set up data frame and titles for graph:
 
    #calculate sample sizes for chosen discipline and make x labels with all eng sample sizes:
    n_1 <-  sum(with(df, year ==1 & score_total > 1), na.rm = TRUE) # score >1 to ignore NA    
    year1 <- paste0("First Year\nn = ", n_1, "   n = ", n_eng_1) #text string for xlabel including sample size
    
    n_2 <-  sum(with(df, year ==2 & score_total > 1), na.rm = TRUE)     
    year2 <- paste0("Second Year\nn = ", n_2, "   n = ", n_eng_2) #text string for xlabel
    
    n_3 <-  sum(with(df, year ==3 & score_total > 1), na.rm = TRUE)     
    year3 <- paste0("Third Year\nn = ", n_3, "   n = ", n_eng_3) #text string for xlabel
    
    n_4 <-  sum(with(df, year ==4 & score_total > 1), na.rm = TRUE)     
    year4 <- paste0("Fourth Year\nn = ", n_4, "   n = ", n_eng_4) #text string for xlabel
    
    df <- rbind(all_eng, df, dummy) #combine selection with all eng to plot comparison
    graph_title <- paste0(disc_name, " CLA Scores")

    
 ## plot description
    ggplot(
      data = df, 
      aes(x = as.factor(year), y = score_total, fill = plan)
      ) +
      geom_hline(
        yintercept = c(963, 1097, 1232, 1367),  #boundaries for CLA mastery levels 
        colour = "red", 
        linetype = 'dashed'
      ) +
      geom_boxplot() + # geom_boxplot must be after stat_boxplot    
      coord_cartesian(xlim = c(0.5,5.9),ylim = c(600, 1600)) +
      labs(title = graph_title, x = "Year", y = "Total CLA+ Score") +
      scale_x_discrete(labels = c(year1, year2, year3, year4)) + #text strings from above with sample sizes
      theme(
        panel.border = element_rect(colour = "grey", fill = NA), #add border around graph
        panel.grid.major.y = element_line("grey"), #change horizonatal line colour (from white)
        panel.background = element_rect("white"), #change background colour
        #legend.position = "bottom", # position legend below graph
        legend.title = element_blank(), #remove legend title
        axis.title.x = element_blank(), # remove x axis title
        axis.text.x = element_text(size = 12), #size of x axis labels
        panel.grid.major.x = element_blank()
        ) +
      scale_fill_manual(
        values =  c("purple", "gold"),
        labels = c(disc_name, "All Engineering")
        )+
      annotate( # add labels for CLA mastery levels
        "text", 
        fontface = "bold", 
        size = 4,
        alpha = c(0.5, 0.5,0.5,0.5,0.5, 0.8), # transparency (0-1)
        x = 5.2, y = c(900, 1030, 1164, 1300, 1430, 1530), 
        label = c("Below Basic", "Basic", "Proficient", "Accomplished", "Advanced", "CLA Mastery Levels"), 
        colour = "red"
      ) # end ggplot description  



    
  }#end plot expression
  ) #end render plot
  
  
# plot graph
output$claPlot <- renderPlot({
  ggsave("plot.pdf", plotInput())
  plotInput()  
})


# download pdf of graph
output$downloadPDF <- downloadHandler(
  filename = function() {"plot.pdf"},
  content = function(file) {
    file.copy("plot.pdf", file, overwrite=TRUE)
  }
)
  
}#end function
) #end shiny server
