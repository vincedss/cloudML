library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel(""),
      
   sidebarLayout(position="right",
    sidebarPanel(width = 3,    
      div(
      id = "form",
      
      textInput("loan_amnt", "Loan Amount", "10000"),
      sliderInput("annual_inc", "Annual Income", 20000, 200000, 15, ticks = FALSE),      
      radioButtons("term", "Loan Duration",
                  choices = list("36 Months" ="36 months", "60 Months" = "60 months")),
      textInput("state", "US State Code", "CA"),
      selectInput("owner", "House Ownership",
                  c("RENT",  "OWN", "MORTGAGE")),
      sliderInput("seniority", "Seniority in current employment (months)", 1, 120, 5, ticks = FALSE),
      textInput("installment", "Desired Installment", "300"),
      actionButton("submit", "Submit", class = "btn-primary")
    )  
    ),
       
    mainPanel(
        
        fluidRow(
            column(4, 
                  HTML('<img align="left" src="https://i.imgur.com/LBPCTRX.png" width="200" height="100" title="source: imgur.com" />')
                  ), 
            column(4, 
                   HTML('<h3 style="text-align:center">Goliath National Bank</h3><h4 style="text-align:center">Loan Pre-Approval</h4>')
                  ),
            column(4, 
                   HTML('<img align="right" src="https://i.imgur.com/LBPCTRX.png" width="200" height="100" title="source: imgur.com" />')
                  )
            
        ),
                                        
        
        fluidRow(align = "center",
            br(),
            h3("You could drive your dream car tomorrow !"),
            br()
       ),
        fluidRow(align = "center",
            #HTML('<div id="main_image"><img align="center" src="https://cdn.gearpatrol.com/wp-content/uploads/2018/12/GOTY-Dream-Cars-Gear-Patrol-lead-full.jpg" width="400" height="300" margin-bottom="20px" /></div>')
            HTML('<div id="main_image"><img align="center" src="https://nextweblink.com/wp-content/uploads/2018/06/dream-car-800x416.jpg" width="576" height="300" margin-bottom="20px" /></div>')     
        ),
        fluidRow(align = "center",
                 uiOutput(outputId = "small")
        ),
        fluidRow(align = "center",
            h4("Enter your information on the right to check your eligibility for a GNB personal loan."),
            br(), 
            tags$hr()     
        ),
    
        
        fluidRow(align = "center",
            h3(textOutput("default")),
            br()
        ),
        
        fluidRow(align = "center",
            uiOutput(outputId = "approval"),
            br()
        ),                        
        
        fluidRow(align = "center",
                tableOutput('table'),
             br()   
        ),
        
        fluidRow(align = "center",
                tableOutput('table2'),
             br()   
        ),
        
        fluidRow(align = "center",
            column(6, uiOutput("moreinfo")), 
            column(6, uiOutput("submitapplication")),     
            br(),
            br()     
                )
        
       
        
        )

                )
  ))