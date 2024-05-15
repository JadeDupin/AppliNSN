setwd("P:/Appli NSN/Appli_ui_server")
#setwd("C:/Jade/Bergonié/Appli NSN")

source("Y:/Jade/Programmation/Rcode_AddFM.R")
#source("C:/Jade/Bergonié/Appli NSN/Rcode_AddFM.R")

library(shiny)

library(shinydashboard)
library(shinydashboardPlus)

library(devtools)

library("DT")

library(shinyjs)

# Define server logic ---------------------------------------------------------------------------------------
function(input, output) {
  
  ## DG - Puissance - Calcul --------------------------------------------------------------------------------
  DG_puiss_calc_puiss <- eventReactive(input$DG_lance_puissance, {
    
    DG_puiss_unif <- c(input$DG_puiss_unif_a, input$DG_puiss_unif_b)
    
    if(input$DG_puiss_repartition_par_groupe == "Fixed"){
      DG_puiss_nbr_sujet_par_groupe <- input$DG_puiss_nbr_sujet_par_grp
    } 
    else if(input$DG_puiss_repartition_par_groupe == "Unif"){
      DG_puiss_nbr_sujet_par_groupe <- DG_puiss_unif
    }
    
    # # Create a Progress object
    # progress <- shiny::Progress$new()
    # 
    # # Make sure it closes when we exit this reactive, even if there's an error
    # on.exit(progress$close())
    # 
    # progress$set(message = "En cours de calcul...", value = 0)
    # 
    # # Number of times we'll go through the loop
    # n <- input$DG_puiss_nbr_echantillon_MC
    # 
    # for (i in 1:n) {
    #   # Increment the progress bar, and update the detail text.
    #   progress$inc(i)
    #   
    #   # Pause for 0.1 seconds to simulate a long computation.
    #   Sys.sleep(0.1)
    # }
    
    # Appel de la fonction de calcul
    PowerAddFM(Nb_groups = input$DG_puiss_nbr_groupe,
               ni = DG_puiss_nbr_sujet_par_groupe, 
               ni_type = input$DG_puiss_repartition_par_groupe, 
               median_H0 = input$DG_puiss_median_survie_h0,
               Acc_Dur = input$DG_puiss_periode_inclusion, 
               FUP = input$DG_puiss_periode_suivi, 
               FUP_type = input$DG_puiss_type_suivi, 
               HR = input$DG_puiss_HR, 
               shape_W = input$DG_puiss_param_weibull,
               sigma0_2 = input$DG_puiss_variance_0, 
               sigma1_2 = input$DG_puiss_variance_1, 
               rho = input$DG_puiss_correlation_effet, 
               ratio = input$DG_puiss_ratio,
               Y_samples = input$DG_puiss_nbr_echantillon_MC,
               statistic = input$DG_puiss_stat_test, 
               typeIerror = input$DG_puiss_alpha, 
               test_type = input$DG_puiss_type_test, 
               print.cens = FALSE, 
               Bootstrap = input$DG_puiss_bootstrap, 
               Nboot = input$DG_puiss_nboot, 
               seed = input$DG_puiss_seed)
    
  })
  
  ## DG - Puissance - affichage du résultats ----------------------------------------------------------------
  observeEvent(input$DG_lance_puissance, {
    
    shinyjs::show(id ="DG_puiss_res_FR")
    
    output$DG_puiss_valeur_res <- renderUI({
      str1 <- paste("Puissance :", DG_puiss_calc_puiss()$power)
      str2 <- paste("Intervalle de confiance de la puissance : [", DG_puiss_calc_puiss()$powerCI[1], ";", DG_puiss_calc_puiss()$powerCI[2], "]")
      str3 <- paste("se_beta_H0 :", DG_puiss_calc_puiss()$se_beta_H0)
      str4 <- paste("se_beta_HA :", DG_puiss_calc_puiss()$se_beta_HA)
      str5 <- paste("se_sigma0_2 :", DG_puiss_calc_puiss()$se_sigma0_2)
      str6 <- paste("se_sigma1_2 :", DG_puiss_calc_puiss()$se_sigma1_2)
      str7 <- paste("se_rho :", DG_puiss_calc_puiss()$se_rho)
      str8 <- paste("se_cov :", DG_puiss_calc_puiss()$se_cov)
      
      HTML(paste(str1,
                 str2,
                 str3,
                 str4,
                 str5,
                 str6,
                 str7,
                 str8,
                 sep = '<br/>'))
    })
  })
  
  
  ## DG - NSN - Calcul --------------------------------------------------------------------------------------
  DG_NSN_calc_NSN <- eventReactive(input$DG_lance_NSN, {
    
    DG_NSN_unif <- c(input$DG_NSN_unif_a, input$DG_NSN_unif_b)
    
    if(input$DG_NSN_repartition_par_groupe == "Fixed"){
      DG_NSN_nbr_sujet_par_groupe <- input$DG_NSN_nbr_sujet_par_grp
    } 
    else if(input$DG_NSN_repartition_par_groupe == "Unif"){
      DG_NSN_nbr_sujet_par_groupe <- DG_NSN_unif
    }
    
    NSNaddFM(power = input$DG_NSN_puissance, 
             ni = DG_NSN_nbr_sujet_par_groupe,
             ni_type = input$DG_NSN_repartition_par_groupe, 
             median_H0 = input$DG_NSN_median_survie_h0,
             Acc_Dur = input$DG_NSN_periode_inclusion, 
             FUP = input$DG_NSN_periode_suivi, 
             FUP_type = input$DG_NSN_type_suivi, 
             Y_samples = input$DG_NSN_nbr_echantillon_MC,
             HR = input$DG_NSN_HR, 
             shape_W = input$DG_NSN_param_weibull, 
             ratio = input$DG_NSN_ratio, 
             sigma0_2 = input$DG_NSN_variance_0, 
             sigma1_2 = input$DG_NSN_variance_1, 
             rho = input$DG_NSN_correlation_effet, 
             seed = input$DG_NSN_seed, 
             print.cens = FALSE,
             statistic = input$DG_NSN_stat_test, 
             typeIerror = input$DG_NSN_alpha, 
             test_type = input$DG_NSN_type_test, 
             Bootstrap = input$DG_NSN_bootstrap, 
             Nboot = input$DG_NSN_nboot)
    
  })
  
  ## DG - NSN - affichage du résultats ----------------------------------------------------------------------
  observeEvent(input$DG_lance_NSN, {
    
    shinyjs::show(id = "DG_NSN_res_FR")
    
    output$DG_NSN_valeur_res <- renderUI({
      str1 <- paste("Nombre de groupes nécessaires :", DG_NSN_calc_NSN()$G)
      str2 <- paste("Intervalle de confiance du nombre de groupe : [", DG_NSN_calc_NSN()$G_CI[1], ";", DG_NSN_calc_NSN()$G_CI[2], "]")
      
      if(length(DG_NSN_calc_NSN()$ni) == 2){
        str3 <- paste("Nombre de sujets par groupe : U(", DG_NSN_calc_NSN()$ni[1], ";", DG_NSN_calc_NSN()$ni[2], ")")
      }
      else if(length(DG_NSN_calc_NSN()$ni) == 1){
        str3 <- paste("Nombre de sujets par groupe :", DG_NSN_calc_NSN()$ni)
      }
      
      str4 <- paste("Type de répartition des sujets :", DG_NSN_calc_NSN()$ni_type)
      str5 <- paste("True power :", DG_NSN_calc_NSN()$true_power)
      str6 <- paste("Erreur de type I :", DG_NSN_calc_NSN()$alpha)
      str7 <- paste("HR :", DG_NSN_calc_NSN()$HR)
      
      HTML(paste(str1,
                 str2,
                 str3,
                 str4,
                 str5,
                 str6,
                 str7,
                 sep = '<br/>'))
    })
  })
}
