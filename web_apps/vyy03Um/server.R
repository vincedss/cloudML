library(dataiku)
library(shiny)
library(httr)
library(jsonlite)
shinyjs::useShinyjs()
library(dplyr)

shinyServer(function(input, output) {

# STORE FORM RESPONSES     
saveData <- function(data) {
  data <- as.data.frame(t(data))
    responses <<- data
  }


  # Select the form input fields
  fieldsAll = c("loan_amnt", "annual_inc", "term", "state", "owner", "seniority", "installment") 
  
  # Transpose the data to a list 
  aggrData <- reactive({
      data <- sapply(fieldsAll, function(x) input[[x]])
      data
    })
  
  observeEvent(input$submit, {
      saveData(aggrData())
    })    
     
  
  ####### FUNCTION TO PROCESS FORM DATA UPON SUBMISSION ########
  formData <- reactive({
  data <- sapply(fieldsAll, function(x) input[[x]])
  data <- c(data, timestamp = Sys.time())
  data <- t(data)      
  
  # Create payload for Interest Rate prediction endpoint               
  payload = list(
    loan_amnt = data[[1]],
    term = data[[3]],
    installment = data[[7]],
    addr_state = data[[4]],
    annual_inc = data[[2]],
    emp_length_month = data[[6]],
    home_ownership = data[[5]]
  )

    # Create payload for Loan Default prediction endpoint               
  
    loan_amnt = as.numeric(as.character(data[[1]]))
    term = as.numeric(as.character(substring(data[[3]], 1, 3)))
    installment = data[[7]]
    addr_state = data[[4]]
    annual_inc = data[[2]]
    emp_length_month = data[[6]]
    home_ownership = data[[5]]


   # Score payload with API endpoints                                   
   response_loan_default <- POST("http://prod.dssdemo.dataiku.com:12500//public/api/v1/car-loan-scoring/car-loan/predict",
                    body = toJSON(list(features=payload), auto_unbox=TRUE))
   response_int_rate <- POST("http://prod.dssdemo.dataiku.com:12500//public/api/v1/car-loan-scoring/rate_prediction/predict",
                    body = toJSON(list(features=payload), auto_unbox=TRUE))

   # Parse and format responses
   rate_result <- content(response_int_rate)
   default_result <- content(response_loan_default)
    
    prediction_int_rate <- rate_result$result[[1]]
    prediction_default <- default_result$result[[1]]             

    if (prediction_default == "ok") 
        loan_response = "Thank you! Your pre-application for a GNB loan has been"
        else loan_response = "Sorry! Your application for a GNB loan has been temporarily"
   
    if(prediction_default != "ok")
        src = "http://www.pngall.com/wp-content/uploads/2016/05/Denied-Stamp-PNG-Picture.png"
        else src = "http://www.pngall.com/wp-content/uploads/2/Approved-Stamp-Transparent.png"                 
    
    # Output texts and images for responses
    output$default = renderText({ 
    paste(loan_response)
      })
                 
    output$approval = renderUI({
    tags$img(src = src, width = 150, height = 80)
      })
                 
    if(prediction_default != "")
        {width = 100
        height = 100}                
    else
        {width = 400
        height = 300}
    
    src_main =  "https://cdn.gearpatrol.com/wp-content/uploads/2018/12/GOTY-Dream-Cars-Gear-Patrol-lead-full.jpg"            
    output$small = renderUI({
    tags$img(src = src_main, width = width, height = height)
      })             
                 
   ##### Output DETAILED responses as TABLES  ########
   
   
   # TABLE DF IF RESPONSE IS POSITIVE              
   int_rate = paste(round(prediction_int_rate, 2), "%")              
   loan_cost = round(loan_amnt*(prediction_int_rate/100), 2)
   installment = round((loan_amnt+loan_cost)/term, 2)           
                
   col1 = c("Your proposed Interest Rate is", "Your monthly installments are", "The total cost of your loan is")
   col2 = c(int_rate, installment, loan_cost)
   #rownames = c("int_rate", "installment", "loan_cost")             
                   
   df <- cbind(col1, col2)              
   colnames(df) <- c("Loan Summary", " ")
           
   
   # TABLE DG IF RESPONSE IS POSITIVE        
   response_state = as.character(responses[nrow(responses), 4])
   response_income = as.numeric(as.character(responses[nrow(responses), 2]))
   response_seniority = as.numeric(as.character(responses[nrow(responses), 6]))
   response_loan_amnt = as.numeric(as.character(responses[nrow(responses), 1]))   
   
   state_averages = dkuReadDataset("loan_metrics_by_state", samplingMethod="head", nbRows=1200)      
   response_state_avg = filter(state_averages, addr_state == response_state)   
      
   income_gap = response_income / response_state_avg$annual_inc_avg
   seniority_gap = response_seniority / response_state_avg$emp_length_month_avg
   loan_gap = response_loan_amnt / response_state_avg$loan_amnt_avg           
   
   reco_income = paste("1 - Average Income in your State is", as.character(round(response_state_avg$annual_inc_avg, 0)), "$. If your income is below, try asking your boss for a raise!")  
   reco_seniority = paste("2 - Average Employment Length in your State is", as.character(round(response_state_avg$emp_length_month_avg, 0)), "months. If yours is below, try inventing a time travel machine!")
   reco_general = "3 - Smaller loans and shorter duration loans have a bigger chance of being accepted, try changing your parameters"
   
   bcol_1 = c(reco_income, reco_seniority, reco_general)
   dg = as.data.frame(bcol_1)    
   colnames(dg) <- c("Why am I seeing this?")
   
   
   # RENDER TABLE           
   output$table <- renderTable({ 
        if(prediction_default == "ok")
            df
        else
            dg
  })              
  
  # ADD MORE INFO AND SUBMIT BUTTONS               
  output$moreinfo <- renderUI({
        if(prediction_default != "") {
        actionButton('moreinfo', 'MORE INFO', 
                    icon = icon("th"),
                    onclick ="window.open('https://www.youtube.com/watch?v=dQw4w9WgXcQ', '_blank')")
          }
    })
  output$submitapplication <- renderUI({
        if(prediction_default != "") {
        actionButton('submitapplication', 'SUBMIT APPLICATION', 
                     icon = icon("cloud-download"), 
                     onclick ="window.open('https://www.youtube.com/watch?v=dQw4w9WgXcQ', '_blank')")
          }
    })                 
                 
                 
})  
    
  # Trigger formData function on Submit Button    
  observeEvent(input$submit, {
  formData()
})
  observeEvent(input$submit, {
      removeUI(
        selector = "div:has(> #main_image)"
      )
    })
      
     
      
  
  

  })
   
      

