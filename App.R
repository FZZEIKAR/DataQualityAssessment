library(shiny)
library(fresh)
library(DT)
library(bslib)
library(waiter)
library(shinyalert)
library(writexl)
library(dplyr)
library(shinyjs)
library(shinythemes)
js <- "
$(document).ready(function(){
document.getElementById('my_files').addEventListener('change', function() { 
  if(document.getElementById('my_files').files.length == document.getElementById('num').value) {
    return true;
  } else {
    alert('Warning : The number of uploaded files is not equal to the number of files to upload chosen above !');
    this.value = '';
    return false;
  } 
})
})"
ui<-tagList(
  tags$head(
    tags$style("
         body, html {
            height: 100%;
            scroll-behavior: smooth;
         }
        
        .jumbotron {
            position: relative;
            top: 50px;
            margin-bottom: 0px;
            background-color:transparent; 
            color:#ecf0f1;
            height:100%
        }
        .button_align {
          width: 100%;
          height: 100%;
          padding-left: 0px;
          padding-right: 0px;
        }
        .parallax_1 {
            /* The image used */
            background-image: url('dataquality.jpg');
            
            /* Set a specific height */
            height: 100%;
            margin-left:-15px;   
            margin-right:-15px;
            /* Create the parallax scrolling effect */
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
        .parallax_2 {
            /* The image used */
            background-image: url('dataquality.jpg');
            
            /* Set a specific height */
            height: 400px;
            margin-left:-15px;   
            margin-right:-15px;
            /* Create the parallax scrolling effect */
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }   
        
     ")
  ),
  
  navbarPage(
    theme = bs_theme(
      primary = "#00206a",
      secondary = "rgb(0, 85, 106)"
    ),
    
    useShinyjs(),
    tags$head(tags$script(HTML(js))),
    
    id="main_navbar",
    position="fixed-top",
    title = div(
      tags$a( 
        img(
          src='gradiant.png',
          style="margin-left: -15px;", 
          height = 60
        ), 
        href='http://www.gradiant.fr',
        target="_blank"
      )
    ),
    windowTitle="Data quality assessment",
    collapsible = TRUE,
    tabPanelBody(
      value = "page_1",
      useShinyalert(),
      fluidRow(
        column(
          width = 12,
          div(
            class="parallax_1 ",
            div(
              class="jumbotron",
              h1(class = "page-header",
                 style="color: white",
                 "Data quality assessment") %>% 
                tags$b(),
              br(),
              
              tabsetPanel(type = "tabs",
                          
                          tabPanel('Uploading Data',
                                   tags$style(
                                     "li a {font-size: 15px;
                                     font-weight: bold;
                                     color: #75D6E1}"),
                                   br(),
                                   column(
                                     width = 4,
                                     style= "padding-left: 0",
                                     numericInput("num", p("How many files do you want to upload ?"), value=2, min = 2, max = 5),
                                     textOutput("out1"),
                                     tags$head(tags$style("#out1{color: red;
                                                            font-size: 20px;
                                                            font-style: italic;
                                                            }")),
                                     fileInput(
                                       width = "100%",
                                       "my_files", multiple = T,accept = ".csv",
                                       p("Upload your files :")
                                     ),tags$style(".btn-file {  
                                                  background-color:grey; 
                                                    border-color: grey;}
                                                    .progress-bar {
                                                    background-color:#75D6E1}") ,
                                     br(),
                                     
                                     class="parallax_1 ",
                                     dataTableOutput("files"),
                                     tags$head(tags$style("#files table {background-color: white; }")),
                                     
                                     
                                     br(),
                                     actionButton("Start", "Start analysis", 
                                                  width = "100%", style="color: #fff;
                                                    background-color: #4EBAB5; 
                                                    border-color: black"))),
                          tabPanel('Analysis'),
                          tabPanel('Download results'))
            )
          )
        )
      )
    )
  ),
  div(class="parallax_2 text-center",
      tags$footer(style="color:#ecf0f1",
                  
                  column(width=12, style="height:50px"),
                  p(tags$strong("Made with R Shiny"),
                    tags$br(),
                    tags$strong("by")
                  ),
                  tags$strong("Fatima-Zahra ZEIKAR"),
                  tags$em(tags$strong("Consultante data scientist")),
                  tags$a(href="https://www.linkedin.com/in/fatima-zahra-zeikar-7a03b9153/", icon("linkedin"),target="_blank"),
                  tags$strong(p(icon("address-card"), " fatima-zahra.zeikar@gradiant.fr")),
      )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$num, {
    req(input$num)
    number <- input$num 
    max_number <- 5
    min_number<-2
    if(number > max_number) {
      output$out1<-renderText({'You can not upload more than 5 files !'})}
    if(number < min_number) {
      output$out1<-renderText({'You can not upload less than 2 files !'})}
    if((number <= max_number) & (number >= min_number)) {
      output$out1<-renderText({''})}
    
  })
  my_files<-reactive(input$my_files)
  output$files <- renderDataTable(input$my_files,options = list(paging = FALSE, searching = FALSE))
  
  #for(i in 1:length(input$my_files[,1])){
  #lst[[i]] <- read.csv(input$my_files[[i, 'datapath']])
  #}
  
  
  
}
shinyApp(ui, server)