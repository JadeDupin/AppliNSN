#---------------------------------------------------------------------------------------------------#
# Working directory----------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#

setwd("P:/Appli NSN/Appli_ui_server")
#setwd("Y:/Jade/Appli_ui_server")
#setwd("C:/Jade/Bergonié/Appli NSN")


#---------------------------------------------------------------------------------------------------#
# Lexique--------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
# DG = Données groupées

# BSD = Biomarker strategy design

# DR = Données récurrentes
  # SFM = Shared Frailty Model
  # NFM = Nested Frailty Model
  # JFM = Joint Frailty Model
  # GJFM = General Joint Frailty Model

# puiss = concerne le calcul de puissance
# NSN = concerne le calcul du NSN


#---------------------------------------------------------------------------------------------------#
# Sources--------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#

#DG
source("Y:/Jade/Programmation/1 - Grouped data/Rcode_AddFM.R")
#source("C:/Jade/Bergonié/Appli NSN/Rcode_AddFM.R")


#DR
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_SFM.R")
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_NFM.R")
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_JFM.R")
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_GJFM.R")


#BSD



#---------------------------------------------------------------------------------------------------#
# Librairies-----------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#

library(shiny)

library(shinydashboard)
library(shinydashboardPlus)

library(devtools)

library("DT")

library(shinyjs)

library(stringr)


##==========================================================================================================#
# Début de code #############################################################################################
##==========================================================================================================#

function(input, output) {
  
##----------------------------------------------------------------------------------------------------------#
## Données groupées------------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
  
  ### Puissance - Calcul ------------------------------------------------------------------------------------
  DG_puiss_calc_puiss <- eventReactive(input$DG_lance_puissance, {
    
    DG_puiss_unif <- c(input$DG_puiss_unif_a, input$DG_puiss_unif_b)
    
    if(input$DG_puiss_repartition_par_groupe == "Fixed"){
      DG_puiss_nbr_sujet_par_groupe <- input$DG_puiss_nbr_sujet_par_grp
    } 
    else if(input$DG_puiss_repartition_par_groupe == "Uniform"){
      DG_puiss_nbr_sujet_par_groupe <- DG_puiss_unif
    }
    
    # Appel de la fonction de calcul
    PowerAddFM(Nb_groups   = input$DG_puiss_nbr_groupe,
               ni          = DG_puiss_nbr_sujet_par_groupe, 
               ni_type     = input$DG_puiss_repartition_par_groupe, 
               median_H0   = input$DG_puiss_median_survie_h0,
               Acc_Dur     = input$DG_puiss_periode_inclusion, 
               FUP         = input$DG_puiss_periode_suivi, 
               FUP_type    = input$DG_puiss_type_suivi, 
               HR          = input$DG_puiss_HR, 
               shape_W     = input$DG_puiss_param_weibull,
               sigma0_2    = input$DG_puiss_variance_0, 
               sigma1_2    = input$DG_puiss_variance_1, 
               rho         = input$DG_puiss_correlation_effet, 
               ratio       = input$DG_puiss_ratio,
               Y_samples   = input$DG_puiss_nbr_echantillon_MC,
               statistic   = input$DG_puiss_stat_test, 
               typeIerror  = input$DG_puiss_alpha, 
               test_type   = input$DG_puiss_type_test, 
               print.cens  = FALSE, 
               Bootstrap   = input$DG_puiss_bootstrap, 
               Nboot       = input$DG_puiss_nboot, 
               seed        = input$DG_puiss_seed)
    
  })
  
  ### Puissance - affichage du résultats --------------------------------------------------------------------
  observeEvent(input$DG_lance_puissance, {
    
    shinyjs::show(id = "DG_puiss_res_FR")
    
    output$DG_puiss_valeur_res <- renderUI({
      str1 <- paste("Power:", round(DG_puiss_calc_puiss()$power, digits=3))
      str2 <- paste("Power confidence interval: [", round(DG_puiss_calc_puiss()$powerCI[1], digits=3), ";", round(DG_puiss_calc_puiss()$powerCI[2], digits=3), "]") #condition pour apparaitre que si bootstrap cocher
      
      HTML(paste(str1,
                 if(input$DG_puiss_bootstrap){
                   str2
                   },
                 sep = '<br/>'))
    })
  })
  
  
  ### NSN - Calcul ------------------------------------------------------------------------------------------
  DG_NSN_calc_NSN <- eventReactive(input$DG_lance_NSN, {
    
    DG_NSN_unif <- c(input$DG_NSN_unif_a, input$DG_NSN_unif_b)
    
    if(input$DG_NSN_repartition_par_groupe == "Fixed"){
      DG_NSN_nbr_sujet_par_groupe <- input$DG_NSN_nbr_sujet_par_grp
    } 
    else if(input$DG_NSN_repartition_par_groupe == "Uniform"){
      DG_NSN_nbr_sujet_par_groupe <- DG_NSN_unif
    }
    
    NSNaddFM(power      = input$DG_NSN_puissance, 
             ni         = DG_NSN_nbr_sujet_par_groupe,
             ni_type    = input$DG_NSN_repartition_par_groupe, 
             median_H0  = input$DG_NSN_median_survie_h0,
             Acc_Dur    = input$DG_NSN_periode_inclusion, 
             FUP        = input$DG_NSN_periode_suivi, 
             FUP_type   = input$DG_NSN_type_suivi, 
             Y_samples  = input$DG_NSN_nbr_echantillon_MC,
             HR         = input$DG_NSN_HR, 
             shape_W    = input$DG_NSN_param_weibull, 
             ratio      = input$DG_NSN_ratio, 
             sigma0_2   = input$DG_NSN_variance_0, 
             sigma1_2   = input$DG_NSN_variance_1, 
             rho        = input$DG_NSN_correlation_effet, 
             seed       = input$DG_NSN_seed, 
             print.cens = FALSE,
             statistic  = input$DG_NSN_stat_test, 
             typeIerror = input$DG_NSN_alpha, 
             test_type  = input$DG_NSN_type_test, 
             Bootstrap  = input$DG_NSN_bootstrap, 
             Nboot      = input$DG_NSN_nboot)
    
  })
  
  ### NSN - affichage du résultats --------------------------------------------------------------------------
  observeEvent(input$DG_lance_NSN, {
    
    shinyjs::show(id = "DG_NSN_res_FR")
    
    output$DG_NSN_valeur_res <- renderUI({
      str1 <- paste("Number of groups required:", DG_NSN_calc_NSN()$G)
      str2 <- paste("confidence interval: [", DG_NSN_calc_NSN()$G_CI[1], ";", DG_NSN_calc_NSN()$G_CI[2], "]") #condition pour apparaitre que si bootstrap cocher
      
      if(length(DG_NSN_calc_NSN()$ni) == 2){
        str3 <- paste("Distribution of subject per group: U(", DG_NSN_calc_NSN()$ni[1], ";", DG_NSN_calc_NSN()$ni[2], ")")
      }
      else if(length(DG_NSN_calc_NSN()$ni) == 1){
        str3 <- paste("Number of subject per group:", DG_NSN_calc_NSN()$ni)
      }
      
      str4 <- paste("Type of subject distribution:", DG_NSN_calc_NSN()$ni_type)
      str5 <- paste("True power:", DG_NSN_calc_NSN()$true_power)
      str6 <- paste("Type I error:", DG_NSN_calc_NSN()$alpha)
      str7 <- paste("HR:", DG_NSN_calc_NSN()$HR)
      
      HTML(paste(str1,
                 if(input$DG_NSN_bootstrap){
                   str2
                 },
                 str3,
                 str4,
                 str5,
                 str6,
                 str7,
                 sep = '<br/>'))
    })
  })
  
  
  
##----------------------------------------------------------------------------------------------------------#
## Biomarker strategy Design---------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
  
  
  
  
  
  
##----------------------------------------------------------------------------------------------------------#
## Données récurrentes---------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
  
  ### SFM----------------------------------------------------------------------------------------------------
  
  #### Puissance - Calcul------------------------------------------------------------------------------------
  
  DR_SFM_puiss_calc_puiss <- eventReactive(input$DR_SFM_lance_puissance, {
    
    ## si unif pour répartition events par grp
    DR_SFM_puiss_nbr_events_par_grp_unif <- c(input$DR_SFM_puiss_nbr_events_par_grp_unif_a, input$DR_SFM_puiss_nbr_events_par_grp_unif_b)
    
    if(input$DR_SFM_puiss_repartition_events == "Fixed" || input$DR_SFM_puiss_repartition_events == "Poisson"){
      DR_SFM_puiss_nbr_events_par_groupe <- input$DR_SFM_puiss_nbr_events_par_grp
    } 
    else if(input$DR_SFM_puiss_repartition_events == "Uniform"){
      DR_SFM_puiss_nbr_events_par_groupe <- DR_SFM_puiss_nbr_events_par_grp_unif
    }
    
    
    
    ## si unif pour répartition des décès
    DR_SFM_puiss_censor_death_unif <- c(input$DR_SFM_puiss_cencor_time_death_unif_a, input$DR_SFM_puiss_cencor_time_death_unif_b)
    
    if(input$DR_SFM_puiss_distrib_death == "Exponential"){
      DR_SFM_puiss_censor_death <- input$DR_SFM_puiss_cencor_time_death
    } 
    else if(input$DR_SFM_puiss_distrib_death == "Uniform"){
      DR_SFM_puiss_censor_death <- DR_SFM_puiss_censor_death_unif
    }
    
    
    
    # Appel de la fonction de calcul
    PowerSharedFM(Groups      = input$DR_SFM_puiss_nbr_groupe,
                  ni          = DR_SFM_puiss_nbr_events_par_groupe,
                  ni_type     = input$DR_SFM_puiss_repartition_events, 
                  median_H0   = input$DR_SFM_puiss_median_survie_h0,
                  Acc_Dur     = input$DR_SFM_puiss_periode_inclusion, 
                  FUP         = input$DR_SFM_puiss_periode_suivi, 
                  FUP_type    = input$DR_SFM_puiss_type_suivi, 
                  beta0       = log(input$DR_SFM_puiss_beta0),
                  betaA       = log(input$DR_SFM_puiss_betaA), 
                  shape_W     = input$DR_SFM_puiss_param_weibull,
                  theta       = input$DR_SFM_puiss_theta, 
                  ratio       = input$DR_SFM_puiss_ratio, 
                  Y_samples   = input$DR_SFM_puiss_nbr_echantillon_MC, 
                  death_par   = DR_SFM_puiss_censor_death, 
                  death_type  = input$DR_SFM_puiss_distrib_death,
                  statistic   = input$DR_SFM_puiss_stat_test, 
                  typeIerror  = input$DR_SFM_puiss_alpha, 
                  test_type   = input$DR_SFM_puiss_type_test, 
                  print.cens  = FALSE, 
                  timescale   = input$DR_SFM_puiss_timescale,
                  data_type   = input$DR_SFM_puiss_type_data, 
                  seed        = input$DR_SFM_puiss_seed)
    
  })
  
  
  #### Puissance - affichage du résultats -------------------------------------------------------------------
  observeEvent(input$DR_SFM_lance_puissance, {
    
    shinyjs::show(id = "DR_SFM_puiss_res_FR")
    
    output$DR_SFM_puiss_valeur_res <- renderUI({
      str1 <- paste("Power:", round(DR_SFM_puiss_calc_puiss()$power, digits=3))
      str2 <- paste("Under H0, N° events:", round(DR_SFM_puiss_calc_puiss()$events[1], digits=2), "au total")
      str3 <- paste("Under HA, N° events:", round(DR_SFM_puiss_calc_puiss()$events[2], digits=2), "au total")
      
      HTML(paste(str1,
                 str2,
                 str3,
                 sep = '<br/>'))
    })
  })
  
  
  #### NSN - Calcul------------------------------------------------------------------------------------
  
  DR_SFM_NSN_calc_NSN <- eventReactive(input$DR_SFM_lance_NSN, {
    ## si unif pour répartition events par grp
    DR_SFM_NSN_nbr_events_par_grp_unif <- c(input$DR_SFM_NSN_nbr_events_par_grp_unif_a, input$DR_SFM_NSN_nbr_events_par_grp_unif_b)
    
    if(input$DR_SFM_NSN_repartition_events == "Fixed" || input$DR_SFM_NSN_repartition_events == "Poisson"){
      DR_SFM_NSN_nbr_events_par_groupe <- input$DR_SFM_NSN_nbr_events_par_grp
    } 
    else if(input$DR_SFM_NSN_repartition_events == "Uniform"){
      DR_SFM_NSN_nbr_events_par_groupe <- DR_SFM_NSN_nbr_events_par_grp_unif
    }
    
    
    
    ## si unif pour répartition des décès
    DR_SFM_NSN_censor_death_unif <- c(input$DR_SFM_NSN_cencor_time_death_unif_a, input$DR_SFM_NSN_cencor_time_death_unif_b)
    
    if(input$DR_SFM_NSN_distrib_death == "Exponential"){
      DR_SFM_NSN_censor_death <- input$DR_SFM_NSN_cencor_time_death
    } 
    else if(input$DR_SFM_NSN_distrib_death == "Uniform"){
      DR_SFM_NSN_censor_death <- DR_SFM_NSN_censor_death_unif
    }
    
    
    
    # Appel de la fonction de calcul
    NsnSharedFM(power       = input$DR_SFM_NSN_puissance, 
                ni          = DR_SFM_NSN_nbr_events_par_groupe,
                ni_type     = input$DR_SFM_NSN_repartition_events, 
                median_H0   = input$DR_SFM_NSN_median_survie_h0,
                Acc_Dur     = input$DR_SFM_NSN_periode_inclusion, 
                FUP         = input$DR_SFM_NSN_periode_suivi, 
                FUP_type    = input$DR_SFM_NSN_type_suivi, 
                beta0       = log(input$DR_SFM_NSN_beta0),
                betaA       = log(input$DR_SFM_NSN_betaA), 
                shape_W     = input$DR_SFM_NSN_param_weibull,
                theta       = input$DR_SFM_NSN_theta, 
                ratio       = input$DR_SFM_NSN_ratio, 
                Y_samples   = input$DR_SFM_NSN_nbr_echantillon_MC, 
                death_par   = DR_SFM_NSN_censor_death, 
                death_type  = input$DR_SFM_NSN_distrib_death,
                statistic   = input$DR_SFM_NSN_stat_test, 
                typeIerror  = input$DR_SFM_NSN_alpha, 
                test_type   = input$DR_SFM_NSN_type_test, 
                print.cens  = FALSE, 
                timescale   = input$DR_SFM_NSN_timescale,
                seed        = input$DR_SFM_NSN_seed, 
                data_type   = input$DR_SFM_NSN_type_data)
  })
  
  
  #### NSN - affichage du résultats -------------------------------------------------------------------------
  
  observeEvent(input$DR_SFM_lance_NSN, {
    
    shinyjs::show(id = "DR_SFM_NSN_res_FR")

    output$DR_SFM_NSN_valeur_res <- renderUI({
      str1 <- paste("Number of subject:", DR_SFM_NSN_calc_NSN()$Npts)

      if(DR_SFM_NSN_calc_NSN()$ni_type == "Uniform"){
        str2 <- paste("Distribution of subject per group: U(", DR_SFM_NSN_calc_NSN()$ni[1], ";", DR_SFM_NSN_calc_NSN()$ni[2], ")")
      }
      else if(DR_SFM_NSN_calc_NSN()$ni_type == "Fixed"){
        str2 <- paste("Number of expected events:", DR_SFM_NSN_calc_NSN()$ni)
      }
      else if(DR_SFM_NSN_calc_NSN()$ni_type == "Poisson"){
        str2 <- paste("Parameter of a poisson distribution: P(", DR_SFM_NSN_calc_NSN()$ni, ")")
      }

      str3 <- paste("Type of events distribution:", DR_SFM_NSN_calc_NSN()$ni_type)
      str4 <- paste("True power:", round(DR_SFM_NSN_calc_NSN()$true_power, digits=3))
      str5 <- paste("Type I error:", DR_SFM_NSN_calc_NSN()$alpha)
      str6 <- paste("Under H0, N° events:", round(DR_SFM_NSN_calc_NSN()$events[1], digits = 2), "au total")
      str7 <- paste("Under HA, N° events:", round(DR_SFM_NSN_calc_NSN()$events[2], digits = 2), "au total")

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
  
  
  
  ### NFM----------------------------------------------------------------------------------------------------
  
  #### Puissance - Calcul------------------------------------------------------------------------------------
  
  DR_NFM_puiss_calc_puiss <- eventReactive(input$DR_NFM_lance_puissance, {
    
    ## si unif pour répartition subgroups
    DR_NFM_puiss_nbr_subgrp_unif <- c(input$DR_NFM_puiss_nbr_subgroups_unif_a, input$DR_NFM_puiss_nbr_subgroups_unif_b)
    
    if(input$DR_NFM_puiss_repartition_subgroups == "Fixed" || input$DR_NFM_puiss_repartition_subgroups == "Poisson"){
      DR_NFM_puiss_nbr_subgrp <- input$DR_NFM_puiss_nbr_subgroups
    } 
    else if(input$DR_NFM_puiss_repartition_subgroups == "Uniform"){
      DR_NFM_puiss_nbr_subgrp <- DR_NFM_puiss_nbr_subgrp_unif
    }
    
    
    ## si unif pour répartition events
    DR_NFM_puiss_nbr_events_par_subgrp_unif <- c(input$DR_NFM_puiss_nbr_events_par_subgrp_unif_a, input$DR_NFM_puiss_nbr_events_par_subgrp_unif_b)
    
    if(input$DR_NFM_puiss_repartition_events == "Fixed" || input$DR_NFM_puiss_repartition_events == "Poisson"){
      DR_NFM_puiss_nbr_events_par_groupe <- input$DR_NFM_puiss_nbr_events_par_subgrp
    } 
    else if(input$DR_NFM_puiss_repartition_events == "Uniform"){
      DR_NFM_puiss_nbr_events_par_groupe <- DR_NFM_puiss_nbr_events_par_subgrp_unif
    }
    
    
    ## si unif pour répartition des décès
    DR_NFM_puiss_censor_death_unif <- c(input$DR_NFM_puiss_cencor_time_death_unif_a, input$DR_NFM_puiss_cencor_time_death_unif_b)
    
    if(input$DR_NFM_puiss_distrib_death == "Exponential"){
      DR_NFM_puiss_censor_death <- input$DR_NFM_puiss_cencor_time_death
    } 
    else if(input$DR_NFM_puiss_distrib_death == "Uniform"){
      DR_NFM_puiss_censor_death <- DR_NFM_puiss_censor_death_unif
    }
    
    
    
    # Appel de la fonction de calcul
    PowerNestedFM(Groups      = input$DR_NFM_puiss_nbr_groupe,
                  ni          = DR_NFM_puiss_nbr_subgrp,
                  ni_type     = input$DR_NFM_puiss_repartition_subgroups, 
                  median_H0   = input$DR_NFM_puiss_median_survie_h0,
                  kij         = DR_NFM_puiss_nbr_events_par_groupe,
                  kij_type    = input$DR_NFM_puiss_repartition_events,
                  Acc_Dur     = input$DR_NFM_puiss_periode_inclusion, 
                  FUP         = input$DR_NFM_puiss_periode_suivi, 
                  FUP_type    = input$DR_NFM_puiss_type_suivi, 
                  beta0       = log(input$DR_NFM_puiss_beta0),
                  betaA       = log(input$DR_NFM_puiss_betaA), 
                  shape_W     = input$DR_NFM_puiss_param_weibull,
                  theta       = input$DR_NFM_puiss_theta,
                  eta         = input$DR_NFM_puiss_eta,
                  ratio       = input$DR_NFM_puiss_ratio, 
                  Y_samples   = input$DR_NFM_puiss_nbr_echantillon_MC, 
                  death_par   = DR_NFM_puiss_censor_death, 
                  death_type  = input$DR_NFM_puiss_distrib_death,
                  statistic   = input$DR_NFM_puiss_stat_test, 
                  typeIerror  = input$DR_NFM_puiss_alpha, 
                  test_type   = input$DR_NFM_puiss_type_test, 
                  print.cens  = FALSE, 
                  timescale   = input$DR_NFM_puiss_timescale,
                  data_type   = input$DR_NFM_puiss_type_data, 
                  seed        = input$DR_NFM_puiss_seed)
    
    
  })
  
  
  #### Puissance - affichage du résultats -------------------------------------------------------------------
  observeEvent(input$DR_NFM_lance_puissance, {
    
    shinyjs::show(id = "DR_NFM_puiss_res_FR")
    
    output$DR_NFM_puiss_valeur_res <- renderUI({
      str1 <- paste("Power:", round(DR_NFM_puiss_calc_puiss()$power, digits=3))
      str2 <- paste("Under H0, N° events:", round(DR_NFM_puiss_calc_puiss()$events[1], digits=2), "au total")
      str3 <- paste("Under HA, N° events:", round(DR_NFM_puiss_calc_puiss()$events[2], digits=2), "au total")
      
      HTML(paste(str1,
                 str2,
                 str3,
                 sep = '<br/>'))
    })
  })
  
  
  #### NSN - Calcul------------------------------------------------------------------------------------
  
  DR_NFM_NSN_calc_NSN <- eventReactive(input$DR_NFM_lance_NSN, {
    
    ## si unif pour répartition subgroups
    DR_NFM_NSN_nbr_subgrp_unif <- c(input$DR_NFM_NSN_nbr_subgroups_unif_a, input$DR_NFM_NSN_nbr_subgroups_unif_b)
    
    if(input$DR_NFM_NSN_repartition_subgroups == "Fixed" || input$DR_NFM_NSN_repartition_subgroups == "Poisson"){
      DR_NFM_NSN_nbr_subgrp <- input$DR_NFM_NSN_nbr_subgroups
    } 
    else if(input$DR_NFM_NSN_repartition_subgroups == "Uniform"){
      DR_NFM_NSN_nbr_subgrp <- DR_NFM_NSN_nbr_subgrp_unif
    }
    
    
    ## si unif pour répartition events
    DR_NFM_NSN_nbr_events_par_subgrp_unif <- c(input$DR_NFM_NSN_nbr_events_par_subgrp_unif_a, input$DR_NFM_NSN_nbr_events_par_subgrp_unif_b)
    
    if(input$DR_NFM_NSN_repartition_events == "Fixed" || input$DR_NFM_NSN_repartition_events == "Poisson"){
      DR_NFM_NSN_nbr_events_par_groupe <- input$DR_NFM_NSN_nbr_events_par_subgrp
    } 
    else if(input$DR_NFM_NSN_repartition_events == "Uniform"){
      DR_NFM_NSN_nbr_events_par_groupe <- DR_NFM_NSN_nbr_events_par_subgrp_unif
    }
    
    
    ## si unif pour répartition des décès
    DR_NFM_NSN_censor_death_unif <- c(input$DR_NFM_NSN_cencor_time_death_unif_a, input$DR_NFM_NSN_cencor_time_death_unif_b)
    
    if(input$DR_NFM_NSN_distrib_death == "Exponential"){
      DR_NFM_NSN_censor_death <- input$DR_NFM_NSN_cencor_time_death
    } 
    else if(input$DR_NFM_NSN_distrib_death == "Uniform"){
      DR_NFM_NSN_censor_death <- DR_NFM_NSN_censor_death_unif
    }
    
    
    
    # Appel de la fonction de calcul
    NsnNestedFM(power      = input$DR_NFM_NSN_puissance,
                ni          = DR_NFM_NSN_nbr_subgrp,
                ni_type     = input$DR_NFM_NSN_repartition_subgroups, 
                median_H0   = input$DR_NFM_NSN_median_survie_h0,
                kij         = DR_NFM_NSN_nbr_events_par_groupe,
                kij_type    = input$DR_NFM_NSN_repartition_events,
                Acc_Dur     = input$DR_NFM_NSN_periode_inclusion, 
                FUP         = input$DR_NFM_NSN_periode_suivi, 
                FUP_type    = input$DR_NFM_NSN_type_suivi, 
                beta0       = log(input$DR_NFM_NSN_beta0),
                betaA       = log(input$DR_NFM_NSN_betaA), 
                shape_W     = input$DR_NFM_NSN_param_weibull,
                theta       = input$DR_NFM_NSN_theta,
                eta         = input$DR_NFM_NSN_eta,
                ratio       = input$DR_NFM_NSN_ratio, 
                Y_samples   = input$DR_NFM_NSN_nbr_echantillon_MC, 
                death_par   = DR_NFM_NSN_censor_death, 
                death_type  = input$DR_NFM_NSN_distrib_death,
                statistic   = input$DR_NFM_NSN_stat_test, 
                typeIerror  = input$DR_NFM_NSN_alpha, 
                test_type   = input$DR_NFM_NSN_type_test, 
                print.cens  = FALSE, 
                timescale   = input$DR_NFM_NSN_timescale,
                data_type   = input$DR_NFM_NSN_type_data, 
                seed        = input$DR_NFM_NSN_seed)
    
  })
  
  
  #### NSN - affichage du résultats -------------------------------------------------------------------------
  
  observeEvent(input$DR_NFM_lance_NSN, {
    
    shinyjs::show(id = "DR_NFM_NSN_res_FR")
    
    output$DR_NFM_NSN_valeur_res <- renderUI({
      str1 <- paste("Number of subject:", DR_NFM_NSN_calc_NSN()$Groups)
      
      if(DR_NFM_NSN_calc_NSN()$ni_type == "Uniform"){
        str2 <- paste("Distribution uniform of subgroups: U(", DR_NFM_NSN_calc_NSN()$ni[1], ";", DR_NFM_NSN_calc_NSN()$ni[2], ")")
      }
      else if(DR_NFM_NSN_calc_NSN()$ni_type == "Fixed"){
        str2 <- paste("Number of subgroups:", DR_NFM_NSN_calc_NSN()$ni)
      }
      else if(DR_NFM_NSN_calc_NSN()$ni_type == "Poisson"){
        str2 <- paste("Parameter of a poisson distribution for subgroups: P(", DR_NFM_NSN_calc_NSN()$ni, ")")
      }
      
      str3 <- paste("Type of subgroups distribution:", DR_NFM_NSN_calc_NSN()$ni_type)
      
      if(DR_NFM_NSN_calc_NSN()$kij_type == "Uniform"){
        str4 <- paste("Distribution of events per group: U(", DR_NFM_NSN_calc_NSN()$kij[1], ";", DR_NFM_NSN_calc_NSN()$kij[2], ")")
      }
      else if(DR_NFM_NSN_calc_NSN()$kij_type == "Fixed"){
        str4 <- paste("Number of expected events:", DR_NFM_NSN_calc_NSN()$kij)
      }
      else if(DR_NFM_NSN_calc_NSN()$kij_type == "Poisson"){
        str4 <- paste("Parameter of a poisson distribution for events: P(", DR_NFM_NSN_calc_NSN()$kij, ")")
      }
      
      str5 <- paste("Type of events distribution:", DR_NFM_NSN_calc_NSN()$ni_type)
      
      str6 <- paste("True power:", round(DR_NFM_NSN_calc_NSN()$true_power, digits=3))
      str7 <- paste("Type I error:", DR_NFM_NSN_calc_NSN()$alpha)
      str8 <- paste("Under H0, N° events:", round(DR_NFM_NSN_calc_NSN()$events[1], digits = 2), "au total")
      str9 <- paste("Under HA, N° events:", round(DR_NFM_NSN_calc_NSN()$events[2], digits = 2), "au total")
      
      HTML(paste(str1,
                 str2,
                 str3,
                 str4,
                 str5,
                 str6,
                 str7,
                 str8,
                 str9,
                 sep = '<br/>'))
      
    })
  })
  
  
  
  ### JFM----------------------------------------------------------------------------------------------------
  
  #### Puissance - Calcul------------------------------------------------------------------------------------
  
  DR_JFM_puiss_calc_puiss <- eventReactive(input$DR_JFM_lance_puissance, {
    
    ## si unif pour répartition events par grp
    DR_JFM_puiss_nbr_events_par_grp_unif <- c(input$DR_JFM_puiss_nbr_events_par_grp_unif_a, input$DR_JFM_puiss_nbr_events_par_grp_unif_b)
    
    if(input$DR_JFM_puiss_repartition_events == "Maximum" || input$DR_JFM_puiss_repartition_events == "Poisson"){
      DR_JFM_puiss_nbr_events_par_groupe <- input$DR_JFM_puiss_nbr_events_par_grp
    } 
    else if(input$DR_JFM_puiss_repartition_events == "Uniform"){
      DR_JFM_puiss_nbr_events_par_groupe <- DR_JFM_puiss_nbr_events_par_grp_unif
    }
    
    
    # Appel de la fonction de calcul
    PowerJFM(N_Pts       = input$DR_JFM_puiss_nbr_groupe,
             ni          = DR_JFM_puiss_nbr_events_par_groupe,
             ni_type     = input$DR_JFM_puiss_repartition_events,
             medianR_H0  = input$DR_JFM_puiss_median_rec_h0, 
             medianD_H0  = input$DR_JFM_puiss_median_term_h0,
             Acc_Dur     = input$DR_JFM_puiss_periode_inclusion, 
             FUP         = input$DR_JFM_puiss_periode_suivi, 
             FUP_type    = input$DR_JFM_puiss_type_suivi,
             method      = input$DR_JFM_puiss_method, 
             betaR_0     = log(input$DR_JFM_puiss_betaR0),
             betaR_A     = log(input$DR_JFM_puiss_betaRA), 
             betaD_0     = log(input$DR_JFM_puiss_betaD0),
             betaD_A     = log(input$DR_JFM_puiss_betaDA), 
             shapeR_W    = input$DR_JFM_puiss_weibullR, 
             shapeD_W    = input$DR_JFM_puiss_weibullD,
             theta       = input$DR_JFM_puiss_theta, 
             alpha       = input$DR_JFM_puiss_alpha, 
             ratio       = input$DR_JFM_puiss_ratio, 
             Y_samples   = input$DR_JFM_puiss_nbr_echantillon_MC,
             timescale   = input$DR_JFM_puiss_timescale, 
             statistic   = input$DR_JFM_puiss_stat_test, 
             typeIerror  = input$DR_JFM_puiss_typIerror, 
             test_type   = input$DR_JFM_puiss_type_test,
             print.cens  = FALSE,
             seed        = input$DR_JFM_puiss_seed)
    
  })
  
  
  #### Puissance - affichage du résultats -------------------------------------------------------------------
  observeEvent(input$DR_JFM_lance_puissance, {
    
    shinyjs::show(id = "DR_JFM_puiss_res_FR")
    
    output$DR_JFM_puiss_valeur_res <- renderUI({
      str1 <- paste("Power:", round(DR_JFM_puiss_calc_puiss()$power, digits=3))
      
      str2 <- paste("Recurrent events:")
      str3 <- paste("Under H0, N° events:", round(DR_JFM_puiss_calc_puiss()$events_rec[1], digits=2), "au total")
      str4 <- paste("Under HA, N° events:", round(DR_JFM_puiss_calc_puiss()$events_rec[2], digits=2), "au total")
      
      str5 <- paste("Terminal events:")
      str6 <- paste("Under H0, N° events:", round(DR_JFM_puiss_calc_puiss()$events_D[1], digits=2), "au total")
      str7 <- paste("Under HA, N° events:", round(DR_JFM_puiss_calc_puiss()$events_D[2], digits=2), "au total")
      
      HTML(paste(str1,
                 "\n",
                 str2,
                 str3,
                 str4,
                 "\n",
                 str5,
                 str6,
                 str7,
                 sep = '<br/>'))
    })
  })
  
  
  #### NSN - Calcul------------------------------------------------------------------------------------------
  
  DR_JFM_NSN_calc_NSN <- eventReactive(input$DR_JFM_lance_NSN, {
    
    ## si unif pour répartition events par grp
    DR_JFM_NSN_nbr_events_par_grp_unif <- c(input$DR_JFM_NSN_nbr_events_par_grp_unif_a, input$DR_JFM_NSN_nbr_events_par_grp_unif_b)
    
    if(input$DR_JFM_NSN_repartition_events == "Maximum" || input$DR_JFM_NSN_repartition_events == "Poisson"){
      DR_JFM_NSN_nbr_events_par_groupe <- input$DR_JFM_NSN_nbr_events_par_grp
    } 
    else if(input$DR_JFM_NSN_repartition_events == "Uniform"){
      DR_JFM_NSN_nbr_events_par_groupe <- DR_JFM_NSN_nbr_events_par_grp_unif
    }
    
    
    
    # Appel de la fonction de calcul
    NsnJFM(power       = input$DR_JFM_NSN_puissance,
           ni          = DR_JFM_NSN_nbr_events_par_groupe,
           ni_type     = input$DR_JFM_NSN_repartition_events,
           medianR_H0  = input$DR_JFM_NSN_median_rec_h0, 
           medianD_H0  = input$DR_JFM_NSN_median_term_h0,
           Acc_Dur     = input$DR_JFM_NSN_periode_inclusion, 
           FUP         = input$DR_JFM_NSN_periode_suivi, 
           FUP_type    = input$DR_JFM_NSN_type_suivi,
           method      = input$DR_JFM_NSN_method, 
           betaR_0     = log(input$DR_JFM_NSN_betaR0),
           betaR_A     = log(input$DR_JFM_NSN_betaRA), 
           betaD_0     = log(input$DR_JFM_NSN_betaD0),
           betaD_A     = log(input$DR_JFM_NSN_betaDA), 
           shapeR_W    = input$DR_JFM_NSN_weibullR, 
           shapeD_W    = input$DR_JFM_NSN_weibullD,
           theta       = input$DR_JFM_NSN_theta, 
           alpha       = input$DR_JFM_NSN_alpha, 
           ratio       = input$DR_JFM_NSN_ratio, 
           Y_samples   = input$DR_JFM_NSN_nbr_echantillon_MC,
           timescale   = input$DR_JFM_NSN_timescale, 
           statistic   = input$DR_JFM_NSN_stat_test, 
           typeIerror  = input$DR_JFM_NSN_typIerror, 
           test_type   = input$DR_JFM_NSN_type_test,
           print.cens  = FALSE,
           seed        = input$DR_JFM_NSN_seed)
    
  })
  
  
  
  #### NSN - affichage du résultats -------------------------------------------------------------------------
  observeEvent(input$DR_JFM_lance_NSN, {
    
    shinyjs::show(id = "DR_JFM_NSN_res_FR")
    
    output$DR_JFM_NSN_valeur_res <- renderUI({
      
      str1 <- paste("Number of subject:", DR_JFM_NSN_calc_NSN()$Npts)
      
      if(DR_JFM_NSN_calc_NSN()$ni_type == "Uniform"){
        str2 <- paste("Distribution of subject per group: U(", DR_JFM_NSN_calc_NSN()$ni[1], ";", DR_JFM_NSN_calc_NSN()$ni[2], ")")
      }
      else if(DR_JFM_NSN_calc_NSN()$ni_type == "Maximum"){
        str2 <- paste("Number of expected events:", DR_JFM_NSN_calc_NSN()$ni)
      }
      else if(DR_JFM_NSN_calc_NSN()$ni_type == "Poisson"){
        str2 <- paste("Parameter of a poisson distribution: P(", DR_JFM_NSN_calc_NSN()$ni, ")")
      }
      
      str3 <- paste("Type of events distribution:", DR_JFM_NSN_calc_NSN()$ni_type)
      
      str4 <- paste("True power:", round(DR_JFM_NSN_calc_NSN()$true_power, digits=3))
      str5 <- paste("Type I error:", DR_JFM_NSN_calc_NSN()$alpha)
      
      str6 <- paste("Recurrent events:")
      str7 <- paste("Under H0, N° events:", round(DR_JFM_NSN_calc_NSN()$events_rec[1], digits=2), "au total")
      str8 <- paste("Under HA, N° events:", round(DR_JFM_NSN_calc_NSN()$events_rec[2], digits=2), "au total")
      
      str9 <- paste("Terminal events:")
      str10 <- paste("Under H0, N° events:", round(DR_JFM_NSN_calc_NSN()$events_D[1], digits=2), "au total")
      str11 <- paste("Under HA, N° events:", round(DR_JFM_NSN_calc_NSN()$events_D[2], digits=2), "au total")
      
      HTML(paste(str1,
                 str2,
                 str3,
                 str4,
                 str5,
                 "\n",
                 str6,
                 str7,
                 str8,
                 "\n",
                 str9,
                 str10,
                 str11,
                 sep = '<br/>'))
    })
  })
  
  
  
  ### GJFM----------------------------------------------------------------------------------------------------
  
  #### Puissance - Calcul------------------------------------------------------------------------------------
  
  DR_GJFM_puiss_calc_puiss <- eventReactive(input$DR_GJFM_lance_puissance, {
    
    ## si unif pour répartition events par grp
    DR_GJFM_puiss_nbr_events_par_grp_unif <- c(input$DR_GJFM_puiss_nbr_events_par_grp_unif_a, input$DR_GJFM_puiss_nbr_events_par_grp_unif_b)
    
    if(input$DR_GJFM_puiss_repartition_events == "Maximum" || input$DR_GJFM_puiss_repartition_events == "Poisson"){
      DR_GJFM_puiss_nbr_events_par_groupe <- input$DR_GJFM_puiss_nbr_events_par_grp
    } 
    else if(input$DR_GJFM_puiss_repartition_events == "Uniform"){
      DR_GJFM_puiss_nbr_events_par_groupe <- DR_GJFM_puiss_nbr_events_par_grp_unif
    }
    
    
    # Appel de la fonction de calcul
    PowerGJFM(N_Pts       = input$DR_GJFM_puiss_nbr_groupe,
              ni          = DR_GJFM_puiss_nbr_events_par_groupe,
              ni_type     = input$DR_GJFM_puiss_repartition_events,
              medianR_H0  = input$DR_GJFM_puiss_median_rec_h0, 
              medianD_H0  = input$DR_GJFM_puiss_median_term_h0,
              Acc_Dur     = input$DR_GJFM_puiss_periode_inclusion, 
              FUP         = input$DR_GJFM_puiss_periode_suivi, 
              FUP_type    = input$DR_GJFM_puiss_type_suivi,
              method      = input$DR_GJFM_puiss_method, 
              betaR_0     = log(input$DR_GJFM_puiss_betaR0),
              betaR_A     = log(input$DR_GJFM_puiss_betaRA), 
              betaD_0     = log(input$DR_GJFM_puiss_betaD0),
              betaD_A     = log(input$DR_GJFM_puiss_betaDA), 
              shapeR_W    = input$DR_GJFM_puiss_weibullR, 
              shapeD_W    = input$DR_GJFM_puiss_weibullD,
              theta       = input$DR_GJFM_puiss_theta, 
              eta         = input$DR_GJFM_puiss_eta, 
              ratio       = input$DR_GJFM_puiss_ratio, 
              Y_samples   = input$DR_GJFM_puiss_nbr_echantillon_MC,
              timescale   = input$DR_GJFM_puiss_timescale, 
              statistic   = input$DR_GJFM_puiss_stat_test, 
              typeIerror  = input$DR_GJFM_puiss_typIerror, 
              test_type   = input$DR_GJFM_puiss_type_test,
              print.cens  = FALSE,
              seed        = input$DR_GJFM_puiss_seed)
    
  })
  
  
  
  #### Puissance - affichage du résultats -------------------------------------------------------------------
  observeEvent(input$DR_GJFM_lance_puissance, {
    
    shinyjs::show(id = "DR_GJFM_puiss_res_FR")
    
    output$DR_GJFM_puiss_valeur_res <- renderUI({
      str1 <- paste("Power:", round(DR_GJFM_puiss_calc_puiss()$power, digits=3))
      
      str2 <- paste("Recurrent events:")
      str3 <- paste("Under H0, N° events:", round(DR_GJFM_puiss_calc_puiss()$events_rec[1], digits=2), "au total")
      str4 <- paste("Under HA, N° events:", round(DR_GJFM_puiss_calc_puiss()$events_rec[2], digits=2), "au total")
      
      str5 <- paste("Terminal events:")
      str6 <- paste("Under H0, N° events:", round(DR_GJFM_puiss_calc_puiss()$events_D[1], digits=2), "au total")
      str7 <- paste("Under HA, N° events:", round(DR_GJFM_puiss_calc_puiss()$events_D[2], digits=2), "au total")
      
      HTML(paste(str1,
                 "\n",
                 str2,
                 str3,
                 str4,
                 "\n",
                 str5,
                 str6,
                 str7,
                 sep = '<br/>'))
    })
  })
  
  
  
  #### NSN - Calcul------------------------------------------------------------------------------------------
  
  DR_GJFM_NSN_calc_NSN <- eventReactive(input$DR_GJFM_lance_NSN, {
    
    ## si unif pour répartition events par grp
    DR_GJFM_NSN_nbr_events_par_grp_unif <- c(input$DR_GJFM_NSN_nbr_events_par_grp_unif_a, input$DR_GJFM_NSN_nbr_events_par_grp_unif_b)
    
    if(input$DR_GJFM_NSN_repartition_events == "Maximum" || input$DR_GJFM_NSN_repartition_events == "Poisson"){
      DR_GJFM_NSN_nbr_events_par_groupe <- input$DR_GJFM_NSN_nbr_events_par_grp
    } 
    else if(input$DR_GJFM_NSN_repartition_events == "Uniform"){
      DR_GJFM_NSN_nbr_events_par_groupe <- DR_GJFM_NSN_nbr_events_par_grp_unif
    }
    
    
    
    # Appel de la fonction de calcul
    NsnGJFM(power       = input$DR_GJFM_NSN_puissance,
            ni          = DR_GJFM_NSN_nbr_events_par_groupe,
            ni_type     = input$DR_GJFM_NSN_repartition_events,
            medianR_H0  = input$DR_GJFM_NSN_median_rec_h0, 
            medianD_H0  = input$DR_GJFM_NSN_median_term_h0,
            Acc_Dur     = input$DR_GJFM_NSN_periode_inclusion, 
            FUP         = input$DR_GJFM_NSN_periode_suivi, 
            FUP_type    = input$DR_GJFM_NSN_type_suivi,
            method      = input$DR_GJFM_NSN_method, 
            betaR_0     = log(input$DR_GJFM_NSN_betaR0),
            betaR_A     = log(input$DR_GJFM_NSN_betaRA), 
            betaD_0     = log(input$DR_GJFM_NSN_betaD0),
            betaD_A     = log(input$DR_GJFM_NSN_betaDA), 
            shapeR_W    = input$DR_GJFM_NSN_weibullR, 
            shapeD_W    = input$DR_GJFM_NSN_weibullD,
            theta       = input$DR_GJFM_NSN_theta, 
            eta         = input$DR_GJFM_NSN_eta, 
            ratio       = input$DR_GJFM_NSN_ratio, 
            Y_samples   = input$DR_GJFM_NSN_nbr_echantillon_MC,
            timescale   = input$DR_GJFM_NSN_timescale, 
            statistic   = input$DR_GJFM_NSN_stat_test, 
            typeIerror  = input$DR_GJFM_NSN_typIerror, 
            test_type   = input$DR_GJFM_NSN_type_test,
            print.cens  = FALSE,
            seed        = input$DR_GJFM_NSN_seed)
    
  })
  
  
  #### NSN - affichage du résultats -------------------------------------------------------------------------
  observeEvent(input$DR_GJFM_lance_NSN, {
    
    shinyjs::show(id = "DR_GJFM_NSN_res_FR")
    
    output$DR_GJFM_NSN_valeur_res <- renderUI({
      
      str1 <- paste("Number of subject:", DR_GJFM_NSN_calc_NSN()$Npts)
      
      if(DR_GJFM_NSN_calc_NSN()$ni_type == "Uniform"){
        str2 <- paste("Distribution of subject per group: U(", DR_GJFM_NSN_calc_NSN()$ni[1], ";", DR_GJFM_NSN_calc_NSN()$ni[2], ")")
      }
      else if(DR_GJFM_NSN_calc_NSN()$ni_type == "Maximum"){
        str2 <- paste("Number of expected events:", DR_GJFM_NSN_calc_NSN()$ni)
      }
      else if(DR_GJFM_NSN_calc_NSN()$ni_type == "Poisson"){
        str2 <- paste("Parameter of a poisson distribution: P(", DR_GJFM_NSN_calc_NSN()$ni, ")")
      }
      
      str3 <- paste("Type of events distribution:", DR_GJFM_NSN_calc_NSN()$ni_type)
      
      str4 <- paste("True power:", round(DR_GJFM_NSN_calc_NSN()$true_power, digits=3))
      str5 <- paste("Type I error:", DR_GJFM_NSN_calc_NSN()$typeIerror)
      
      str6 <- paste("Recurrent events:")
      str7 <- paste("Under H0, N° events:", round(DR_GJFM_NSN_calc_NSN()$events_rec[1], digits=2), "au total")
      str8 <- paste("Under HA, N° events:", round(DR_GJFM_NSN_calc_NSN()$events_rec[2], digits=2), "au total")
      
      str9 <- paste("Terminal events:")
      str10 <- paste("Under H0, N° events:", round(DR_GJFM_NSN_calc_NSN()$events_D[1], digits=2), "au total")
      str11 <- paste("Under HA, N° events:", round(DR_GJFM_NSN_calc_NSN()$events_D[2], digits=2), "au total")
      
      HTML(paste(str1,
                 str2,
                 str3,
                 str4,
                 str5,
                 "\n",
                 str6,
                 str7,
                 str8,
                 "\n",
                 str9,
                 str10,
                 str11,
                 sep = '<br/>'))
    })
  })
  
}


##==========================================================================================================#
# Fin de code ###############################################################################################
##==========================================================================================================#