library(shiny)

require(rCharts)
require(devtools)

library(reshape2)
library(BH)

# Required by includeMarkdown
library(markdown)

# Plotting 
library(ggplot2)



# Load helper functions
#source("functions.R", local = TRUE)


# Load data
y <- read.csv("Aussie_Population.csv",head=TRUE,sep=",")
y2 <- read.csv("Aussie_Population_Sex.csv",head=TRUE,sep=",")
y3 <- read.csv("Aussie_Population_State1.csv",head=TRUE,sep=",")


# Prepare datasets
  
 # Overall

  w<- split(y,list(y$Sex,y$State))
  
  Data<-sapply(w, function(x) colSums(x[,grep("X",names(y))]))  # sum x Year / State
  
  row.names(Data) <- c("1981": "2014")
  

 # State

  colnames(y3) <- c("State","1981":"2014")
  

   y2$Population <- y2$Population / 1000000

 
  GR <- reshape2::melt(y3)
  GR$variable <- as.numeric(substr(GR$variable,1,4))
  
  names(GR)[1:3] = c("State", "Year","Population")
  
  NEW <- data.frame(GR$Year,GR$State,GR$Population)
  names(NEW)[1:3] = c("Year", "State","Population")
  NEW$Year <- as.integer(NEW$Year)
  NEW$Population <- NEW$Population / 1000000
  
  
# Shiny server 
shinyServer(function(input, output,session) {
  
  
  # Render Plots
  
  # Overall Population
  
  output$AussiePopulation <- renderPlot({
    
    start<-input$range[1] - 1980
    end<-input$range[2] - 1980
    
    overall <- Data[start:end,c('Both.Australia')]
    
    overall <- overall/1000000   # Expressed in Millions
    
    # Render a barplot
    barplot(overall, 
          #  main="Australian population",  <-- already in the title
            ylab="Population",
            xlab="Year", col = rainbow(20))
  })

  

  
  # By sex
  
    output$PopulationBySex <-renderChart({

      start2<-input$range[1] 
     end2<-input$range[2] 
  
    overall2 <- subset(y2, Year>=start2 & Year<=end2)
    
    # Render a nplot
   p1 <- nPlot(Population ~ Year, group = "Sex", data = overall2, type = "multiBarChart")

  
   p1$addParams(dom = 'PopulationBySex')
 
  p1
    })
 
 
 # By State
 
 output$PopulationByState <-renderChart({
 
   start3<-input$range[1] 
   end3<-input$range[2]  
 
  overall3 <- subset(NEW, Year>=start3 & Year<=end3)
 
# Render a nplot
   x1 <- nPlot(Population ~ Year, group = "State", data = overall3, type = "multiBarChart")
 
    x1$addParams(dom = 'PopulationByState')
 
  x1
 

  })  
 


})



