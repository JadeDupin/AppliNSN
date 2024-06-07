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

#Tables help
source("helpTab/helpTab.R")

#DG
# source("Y:/Jade/Programmation/1 - Grouped data/Rcode_AddFM.R")
#source("C:/Jade/Bergonié/Appli NSN/Rcode_AddFM.R")


#DR
# source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_SFM.R")
# source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_NFM.R")
# source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_JFM.R")
# source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_GJFM.R")


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




##==========================================================================================================#
# Début de code #############################################################################################
##==========================================================================================================#

# Define UI for application
dashboardPage(
  skin = "purple",
                     
#########################################################################################################Head
  dashboardHeader(
    title = "Estimation NSN", 
    titleWidth = 250
  ),
                     
#######################################################################################################Sidebar
  dashboardSidebar(
    width = 250,
    
    useShinyjs(),
    
    sidebarMenu(
      ## Items du menu ##
        menuItem("Introduction", tabName = "introduction", icon = icon("info")),
        
        menuItem("Grouped Data", tabName = "donnees_groupees", icon = icon("th"),
                 menuSubItem("Power calculation", tabName = "DG_calc_puissance"),
                 menuSubItem("NSN calculation", tabName = "DG_calc_NSN")),
        
        menuItem("Biomarker strategy Design", tabName = "biomark_strat_design", icon = icon("list"),
                 menuSubItem("Power Calculation", tabName = "BSD_calc_puissance"),
                 menuSubItem("NSN calculation", tabName = "BSD_calc_NSN")),
        
        menuItem("Recurring Data", tabName = "donnees_recurrentes", icon = icon("chart-bar"),
                 menuSubItem("Power Calculation", tabName = "DR_calc_puissance"),
                 menuSubItem("NSN calculation", tabName = "DR_calc_NSN"))
      )
    ),
                     
#########################################################################################################Body
  dashboardBody(
    
    #inclusion du css
    includeCSS("www/styles.css"),
    
    tabItems(
##----------------------------------------------------------------------------------------------------------#
## Introduction----------------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
      tabItem(
        tabName = "introduction",
        tags$h2("Introduction", id = "titre_page"),
        tags$h3("Methods for estimating randomized trial sizes in oncology in the presence of survival data and heterogeneous populations", id = "sous_titre_page"),
        
        tags$br(),
        
        fluidRow(
          id = "intro_FR",
          
          
          h3("Grouped Data", id = "intro_titre"),
          p(id = "intro_texte_descr", "Text and links"),
          
          
          
          tags$br(),
          tags$br(),
          
          
          
          h3("Biomarker strategy Design", id = "intro_titre"),
          p(id = "intro_texte_descr", "Text and links"),
          
          
          
          tags$br(),
          tags$br(),
          
          
          
          h3("Recurring Data", id = "intro_titre"),
          
          h4("Shared frailty model", id="intro_sous_titre"),
          p(id = "intro_texte_descr", "Text and links"),
          
          tags$br(),
          
          h4("Nested frailty model", id="intro_sous_titre"),
          p(id = "intro_texte_descr", "Text and links"),
          
          tags$br(),
          
          h4("Joint frailty model", id="intro_sous_titre"),
          p(id = "intro_texte_descr", "Text and links"),
          
          tags$br(),
          
          h4("General joint frailty model", id="intro_sous_titre"),
          p(id = "intro_texte_descr", "Text and links")
        )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Données groupées------------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
                         
      ### Calcul de puissance================================================================================
                         
      tabItem(
        tabName = "DG_calc_puissance",
        
        tags$h2("Grouped Data", id = "titre_page"),
        
        tabsetPanel(
          tabPanel(
            "Setting",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DG_puiss_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              id = "DG_puiss_data_sujets_FR",
              
              div(
                id="DG_puiss_data_sujets_div",
                
                column(width = 4, numericInput("DG_puiss_nbr_groupe", "Number of groups", 10)),
                
                column(width = 4,
                       selectInput("DG_puiss_repartition_par_groupe", "Distribution of patient by groupe",
                                   c("Fixed",  "Uniform")),
                       
                       conditionalPanel(
                         condition = "input.DG_puiss_repartition_par_groupe == 'Fixed'",
                         numericInput("DG_puiss_nbr_sujet_par_grp", "Number of subjets per group", 15)),
                       
                       conditionalPanel(
                         condition = "input.DG_puiss_repartition_par_groupe == 'Uniform'",
                         numericInput("DG_puiss_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DG_puiss_unif_b", "Parameter b of a uniform distribution", 2))
                        ),
                
                column(width = 4, numericInput("DG_puiss_ratio", "Ratio", 1))
              )
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DG_puiss_info_test_simu_FR",
                  
                h4("Statistic", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_puiss_info_test",
                    
                  selectInput("DG_puiss_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                    
                  numericInput("DG_puiss_alpha", "Type I error", 0.05, min=0, max=0.2),
                    
                  selectInput("DG_puiss_stat_test", "Statistic",
                                c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DG_puiss_fisher",
                  
                  numericInput("DG_puiss_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
                  
                tags$br(),
                  
                h4("Confidence interval", id = "sous_titre_sous_partie"),
                    
                div(
                  id="DG_puiss_simulation",
                  
                  h5("Calculate the confidence interval ?", id="IC_titre"),
                  checkboxInput(inputId = "DG_puiss_bootstrap", label = "Bootstrap", value = FALSE),
                      
                  numericInput("DG_puiss_nboot", "Number of bootstrap resamples", 1000)
                )
              ),
                
              column(
                width = 6,
                id = "DG_puiss_data_essai_col",
                  
                h4("About the trial", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_puiss_data_essai_div",
                    
                  selectInput("DG_puiss_type_suivi", "Type of follow-up",
                                c("UptoEnd",  "Fixed")),
                  tags$br(),
                    
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                    
                  numericInput("DG_puiss_periode_inclusion", "Inclusion period", 24),
                    
                  numericInput("DG_puiss_periode_suivi", "Follow-up period", 30),
                    
                  numericInput("DG_puiss_median_survie_h0", "Median survival time under H0", 12),
                    
                  tags$br(),
                  tags$br(),
                    
                  numericInput("DG_puiss_HR", "Hazard Ratio", value= 0.75, min=0 , max=1),
                    
                  numericInput("DG_puiss_param_weibull", "Shape parameter of Weibull", 1),
                    
                  numericInput("DG_puiss_variance_0", "Variance of the baseline risk", 0.1),
                    
                  numericInput("DG_puiss_variance_1", "Variance of the treatment effect", 0.1),
                    
                  numericInput("DG_puiss_correlation_effet", "Correlation between both random effects", 0.5, min=-1, max=1)
                )
              )
            ),
              
            tags$br(),
              
            div(
              id = "DG_lance_puissance",
                
              actionButton(inputId="DG_lance_puissance", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DG_lance_puissance",
              
              fluidRow(
                id= "DG_puiss_res_FR",
                
                h3(id="DG_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DG_resultat_puissance", htmlOutput(outputId = "DG_puiss_valeur_res"))
                )
              )
            )
          ),
          
          ### Help=========================================================================================
          tabPanel(
            "Help",
              
            h3("Help", id = "sous_titre"),
              
            tags$br(),
            
            div(
              id="DG_tab_help",
              choixTabHelp("DG_help")
            )
          )
        )
      ),
                         
                         
      ### Calcul du NSN======================================================================================
                         
      tabItem(
        tabName = "DG_calc_NSN",
          
        tags$h2("Grouped Data", id = "titre_page" ),
          
        tabsetPanel(
          tabPanel(
            "Setting",
              
            h3("NSN calculation parameters", id = "sous_titre"),
              
            tags$br(),
              
            div(id = "seed",
                numericInput("DG_NSN_seed", label = "Seed", 105795)
            ),
              
            tags$br(),
            tags$br(),
              
            fluidRow(
              id="DG_NSN_data_sujet_FR",
                
              div(
                id="DG_NSN_data_sujet_div",
                  
                column(width = 4,
                       selectInput("DG_NSN_repartition_par_groupe", "Distribution of patient by group",
                                   c("Fixed",  "Uniform"))),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DG_NSN_repartition_par_groupe == 'Fixed'",
                          numericInput("DG_NSN_nbr_sujet_par_grp", "Number of subjects per group", 15)),
                         
                        conditionalPanel(
                          condition = "input.DG_NSN_repartition_par_groupe == 'Uniform'",
                          numericInput("DG_NSN_unif_a", "Parameter a of a uniform distribution", 1),
                          numericInput("DG_NSN_unif_b", "Parameter b of a uniform distribution", 2))
                ),
                  
                column(width = 4, numericInput("DG_NSN_ratio", "Ratio", 1))
              )
            ),
              
            tags$br(),
            tags$br(),
              
            fluidRow(
              column(
                width = 6, 
                id = "DG_NSN_info_test_simu_FR",
                  
                h4("Statistic", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_NSN_info_test",
                    
                  numericInput("DG_NSN_puissance", "Power", 0.8),
                    
                  selectInput("DG_NSN_type_test", "Type of test",
                                c("2-sided",  "1-sided")),
                    
                  numericInput("DG_NSN_alpha", "Type I error", 0.05, min=0, max=0.2),
                    
                  selectInput("DG_NSN_stat_test", "Statistic",
                                c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DG_NSN_fisher",
                  
                  numericInput("DG_NSN_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
                  
                tags$br(),
                
                h4("Confidence interval", id = "sous_titre_sous_partie"),
                
                div(
                  id="DG_NSN_simulation",
                  
                  h5("Calculate the confidence interval ?", id="IC_titre"),
                  checkboxInput(inputId = "DG_NSN_bootstrap", label = "Bootstrap", value = FALSE),
                  
                  numericInput("DG_NSN_nboot", "Number of bootstrap resamples", 1000)
                )
              ),
                
              column(
                width = 6,
                id="DG_NSN_data_essai_col",
                  
                h4("About the trial", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_NSN_data_essai",
                    
                  selectInput("DG_NSN_type_suivi", "Type of follow-up",
                                c("UptoEnd",  "Fixed")),
                  tags$br(),
                    
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                    
                  numericInput("DG_NSN_periode_inclusion", "Inclusion period", 24),
                    
                  numericInput("DG_NSN_periode_suivi", "Follow-up period", 30),
                    
                  numericInput("DG_NSN_median_survie_h0", "Median survival time under H0", 12),
                    
                  tags$br(),
                  tags$br(),
                    
                  numericInput("DG_NSN_HR", "Hazard Ratio", value= 0.75, min=0 , max=1),
                    
                  numericInput("DG_NSN_param_weibull", "Shape parameter of Weibull", 1),
                    
                  numericInput("DG_NSN_variance_0", "Variance of the baseline risk", 0.1),
                    
                  numericInput("DG_NSN_variance_1", "Variance of the treatment effect", 0.1),
                    
                  numericInput("DG_NSN_correlation_effet", "Correlation between both random effects", 0.5, min=-1, max=1)
                )
              )
            ),
              
            tags$br(),
              
            div(
              id = "DG_lance_NSN",
                
              actionButton(inputId="DG_lance_NSN", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DG_lance_NSN",
              
              fluidRow(
                id="DG_NSN_res_FR",
                
                h3(id="DG_resultat_titre", "Résultats"),
                
                tags$br(),
                
                div(
                  column(11, id="DG_resultat_NSN", htmlOutput(outputId = "DG_NSN_valeur_res"))
                )
              )
            )
          ),
          
          ### Help=========================================================================================
          tabPanel(
            "Help",
              
            h3("Help", id = "sous_titre"),
              
            tags$br(),
            
            div(
              id="DG_tab_help",
              choixTabHelp("DG_help")
            )
          )
        )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Biomarker strategy Design---------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
      tabItem(
        tabName = "biomark_strat_design",
          
        tags$h2("Biomarker strategy Design", id = "titre_page"),
        
          tabsetPanel(
            tabPanel(
              "Setting"
            ),
            
            tabPanel(
              "Help",
              
              h3("Help", id = "sous_titre"),
              
              tags$br(),
              
              div(
                id="BSD_tab_help",
                choixTabHelp("BSD_help")
              )
            )
          )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Données récurrentes---------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
      
      ### Calcul de puissance================================================================================
      tabItem(
        tabName = "DR_calc_puissance",
        
        tags$h2("Recurring Data", id = "titre_page"),
        
        tabsetPanel(
          
          #### SFM==========================================================================================
          tabPanel(
            "Shared Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_SFM_puiss_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_SFM_puiss_data_sujets_div",
            
              fluidRow(
                id = "DR_SFM_puiss_data_sujets_FR",
              
                column(width = 3, 
                       numericInput("DR_SFM_puiss_nbr_groupe", "Number of patients", 200)),
                
                column(width = 3,
                       selectInput("DR_SFM_puiss_type_data", "Data type",
                                   c("rec_event"))),
                
                column(width = 3,
                       selectInput("DR_SFM_puiss_repartition_events", "Distribution of events",
                                   c("Fixed",  "Uniform", "Poisson"))),
                
                column(width = 3, 
                       numericInput("DR_SFM_puiss_ratio", "Ratio", 1))
              ),
              
              fluidRow(
                id = "DR_SFM_puiss_data_sujets_FR",
                
                column(width = 3),
                
                column(width = 3),
                
                column(width = 3,
                  conditionalPanel(
                    condition = "input.DR_SFM_puiss_repartition_events == 'Fixed' || input.DR_SFM_puiss_repartition_events == 'Poisson'",
                    numericInput("DR_SFM_puiss_nbr_events_par_grp", "Number of expected events", 15)),
                  
                  conditionalPanel(
                    condition = "input.DR_SFM_puiss_repartition_events == 'Uniform'",
                    numericInput("DR_SFM_puiss_nbr_events_par_grp_unif_a", "Parameter a of a uniform distribution", 5),
                    numericInput("DR_SFM_puiss_nbr_events_par_grp_unif_b", "Parameter b of a uniform distribution", 15))
                ),
                
                column(width = 3)
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_SFM_puiss_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_SFM_puiss_info_test",
                  
                  selectInput("DR_SFM_puiss_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_SFM_puiss_alpha", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_SFM_puiss_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_SFM_puiss_fisher",
                  
                  numericInput("DR_SFM_puiss_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
              ),
              
              column(
                width = 6,
                id = "DR_SFM_puiss_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_SFM_puiss_data_essai_div",
                  
                  selectInput("DR_SFM_puiss_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_SFM_puiss_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_SFM_puiss_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_SFM_puiss_periode_suivi", "Follow-up period", 30),
                  
                  numericInput("DR_SFM_puiss_median_survie_h0", "Median survival time under H0", 12),
                  
                  selectInput("DR_SFM_puiss_distrib_death", "Distribution of death times",
                              c("Uniform",  "Exponential")),
                  
                  conditionalPanel(
                    condition = "input.DR_SFM_puiss_distrib_death == 'Uniform'",
                    fluidRow(
                      column(width = 6,
                             numericInput("DR_SFM_puiss_cencor_time_death_unif_a", "Parameter a of a uniform distribution", 5)),
                      column(width = 6,
                              numericInput("DR_SFM_puiss_cencor_time_death_unif_b", "Parameter b of a uniform distribution", 8))
                    )
                  ),
                  
                  conditionalPanel(
                    condition = "input.DR_SFM_puiss_distrib_death == 'Exponential'",
                    numericInput("DR_SFM_puiss_cencor_time_death", "Censor time for death (parameter λ)", 15)
                  ),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_SFM_puiss_beta0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_SFM_puiss_betaA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75))
                  ),
                  
                  numericInput("DR_SFM_puiss_param_weibull", "Shape parameter of Weibull", 1),
                  
                  numericInput("DR_SFM_puiss_theta", "Variability of the baseline risk at the individual level", 0.25)
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_SFM_lance_puissance",
              
              actionButton(inputId="DR_SFM_lance_puissance", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DR_SFM_lance_puissance",
              
              fluidRow(
                id= "DR_SFM_puiss_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_SFM_resultat_puissance", 
                         htmlOutput(outputId = "DR_SFM_puiss_valeur_res"))
                )
              )
            )
          ),
            
          
          #### NFM==========================================================================================
          tabPanel(
            "Nested Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_NFM_puiss_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_NFM_puiss_data_sujets_div",
              
              fluidRow(
                id = "DR_NFM_puiss_data_sujets_FR",
                
                column(width = 3, 
                       numericInput("DR_NFM_puiss_nbr_groupe", "Number of patients", 50)
                ),
                
                column(width = 3,
                       selectInput("DR_NFM_puiss_type_data", "Data type",
                                   c("rec_event1", "rec_event2"))
                ),
                
                column(width = 3,
                       selectInput("DR_NFM_puiss_repartition_subgroups", "Distribution of subgroups considered",
                                   c("Fixed",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 3, 
                       selectInput("DR_NFM_puiss_repartition_events", "Distribution of events per subgroups",
                                   c("Fixed",  "Uniform", "Poisson"))
                )
              ),
              
              fluidRow(
                id = "DR_NFM_puiss_data_sujets_FR",
                
                column(width = 3, 
                       numericInput("DR_NFM_puiss_ratio", "Ratio", 1)
                ),
                
                column(width = 3),
                
                column(width = 3,
                       conditionalPanel(
                         condition = "input.DR_NFM_puiss_repartition_subgroups == 'Fixed' || input.DR_NFM_puiss_repartition_subgroups == 'Poisson'",
                         numericInput("DR_NFM_puiss_nbr_subgroups", "Number of subgroups", 10)),
                       
                       conditionalPanel(
                         condition = "input.DR_NFM_puiss_repartition_subgroups == 'Uniform'",
                         numericInput("DR_NFM_puiss_nbr_subgroups_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_NFM_puiss_nbr_subgroups_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 3,
                       conditionalPanel(
                         condition = "input.DR_NFM_puiss_repartition_events == 'Fixed' || input.DR_NFM_puiss_repartition_events == 'Poisson'",
                         numericInput("DR_NFM_puiss_nbr_events_par_subgrp", "Number of expected events per subgroup", 15)),
                       
                       conditionalPanel(
                         condition = "input.DR_NFM_puiss_repartition_events == 'Uniform'",
                         numericInput("DR_NFM_puiss_nbr_events_par_subgrp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_NFM_puiss_nbr_events_par_subgrp_unif_b", "Parameter b of a uniform distribution", 5))
                )
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_NFM_puiss_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_NFM_puiss_info_test",
                  
                  selectInput("DR_NFM_puiss_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_NFM_puiss_alpha", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_NFM_puiss_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_NFM_puiss_fisher",
                  
                  numericInput("DR_NFM_puiss_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
              ),
              
              column(
                width = 6,
                id = "DR_NFM_puiss_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_NFM_puiss_data_essai_div",
                  
                  selectInput("DR_NFM_puiss_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_NFM_puiss_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_NFM_puiss_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_NFM_puiss_periode_suivi", "Follow-up period", 30),
                  
                  numericInput("DR_NFM_puiss_median_survie_h0", "Median survival time under H0", 1),
                  
                  selectInput("DR_NFM_puiss_distrib_death", "Distribution of death times",
                              c("Uniform",  "Exponential")),
                  
                  conditionalPanel(
                    condition = "input.DR_NFM_puiss_distrib_death == 'Uniform'",
                    fluidRow(
                      column(width = 6,
                             numericInput("DR_NFM_puiss_cencor_time_death_unif_a", "Parameter a of a uniform distribution", 5)),
                      column(width = 6,
                             numericInput("DR_NFM_puiss_cencor_time_death_unif_b", "Parameter b of a uniform distribution", 8))
                    )
                  ),
                  
                  conditionalPanel(
                    condition = "input.DR_NFM_puiss_distrib_death == 'Exponential'",
                    numericInput("DR_NFM_puiss_cencor_time_death", "Censor time for death (parameter λ)", 5)),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_NFM_puiss_beta0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_NFM_puiss_betaA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75))
                  ),
                  
                  numericInput("DR_NFM_puiss_param_weibull", "Shape parameter of Weibull", 1),
                  
                  fluidRow(
                    column(width = 6,
                      numericInput("DR_NFM_puiss_theta", "Variability of the baseline risk at the cluster level", 0.25)),
                  
                    column(width = 6,
                           numericInput("DR_NFM_puiss_eta", "Variability of the baseline risk at the subcluster level", 0.5))
                  )
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_NFM_lance_puissance",
              
              actionButton(inputId="DR_NFM_lance_puissance", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DR_NFM_lance_puissance",
              
              fluidRow(
                id= "DR_NFM_puiss_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_NFM_resultat_puissance", 
                         htmlOutput(outputId = "DR_NFM_puiss_valeur_res"))
                )
              )
            )
          ),
            
          
          #### JFM==========================================================================================
          tabPanel(
            "Joint Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_JFM_puiss_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_JFM_puiss_data_sujets_div",
              
              fluidRow(
                id = "DR_JFM_puiss_data_sujets_FR",
                
                column(width = 4, 
                       numericInput("DR_JFM_puiss_nbr_groupe", "Number of groups", 20)
                ),
                
                column(width = 4,
                       selectInput("DR_JFM_puiss_repartition_events", "Distribution of events",
                                   c("Maximum",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 4, 
                       numericInput("DR_JFM_puiss_ratio", "Ratio", 1)
                )
              ),
              
              fluidRow(
                id = "DR_JFM_puiss_data_sujets_FR",
                
                column(width = 4),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DR_JFM_puiss_repartition_events == 'Maximum' || input.DR_JFM_puiss_repartition_events == 'Poisson'",
                         numericInput("DR_JFM_puiss_nbr_events_par_grp", "Number of expected events per patient", 5)),
                       
                       conditionalPanel(
                         condition = "input.DR_JFM_puiss_repartition_events == 'Uniform'",
                         numericInput("DR_JFM_puiss_nbr_events_par_grp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_JFM_puiss_nbr_events_par_grp_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 4)
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_JFM_puiss_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_puiss_info_test",
                  
                  selectInput("DR_JFM_puiss_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_JFM_puiss_typIerror", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_JFM_puiss_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_puiss_fisher",
                  
                  numericInput("DR_JFM_puiss_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
                
                tags$br(),
                
                h4("Hazard Ratio", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_puiss_test_beta",
                  
                  selectInput("DR_JFM_puiss_method", "Method",
                              c("joint",  "betaRtest", "betaDtest")),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_puiss_betaR0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                      numericInput("DR_JFM_puiss_betaRA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75)),
                  ),
                  
                  fluidRow(
                    column(width = 6,
                      numericInput("DR_JFM_puiss_betaD0", "Beta values for terminal events under H0 (logarithm of)", value = 1)),
                  
                    column(width = 6,
                      numericInput("DR_JFM_puiss_betaDA", "Beta values for terminal events under HA (logarithm of)", value = 0.85)),
                  )
                )
              ),
              
              column(
                width = 6,
                id = "DR_JFM_puiss_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_puiss_data_essai_div",
                  
                  selectInput("DR_JFM_puiss_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_JFM_puiss_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_JFM_puiss_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_JFM_puiss_periode_suivi", "Follow-up period", 30),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_puiss_median_rec_h0", "Median time of recurrent events under H0", 10)),
                  
                    column(width = 6,
                           numericInput("DR_JFM_puiss_median_term_h0", "Median time of terminal events under H0", 20))
                  ),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_puiss_weibullR", "Shape parameter of Weibull for recurrent events", 1)),
                    
                    column(width = 6, 
                           numericInput("DR_JFM_puiss_weibullD", "Shape parameter of Weibull for terminal events", 1))
                  ),
                  
                  numericInput("DR_JFM_puiss_theta", "Dependence between recurrent and terminal events", 0.05),
                  
                  numericInput("DR_JFM_puiss_alpha", "Association between recurrent and terminal events", 0)
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_JFM_lance_puissance",
              
              actionButton(inputId="DR_JFM_lance_puissance", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DR_JFM_lance_puissance",
              
              fluidRow(
                id= "DR_JFM_puiss_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_JFM_resultat_puissance", 
                         htmlOutput(outputId = "DR_JFM_puiss_valeur_res"))
                )
              )
            )
          ),
           
           
          #### GJFM=========================================================================================
          tabPanel(
            "General Joint Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_GJFM_puiss_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_GJFM_puiss_data_sujets_div",
              
              fluidRow(
                id = "DR_GJFM_puiss_data_sujets_FR",
                
                column(width = 4, 
                       numericInput("DR_GJFM_puiss_nbr_groupe", "Number of groups", 20)
                ),
                
                column(width = 4,
                       selectInput("DR_GJFM_puiss_repartition_events", "Distribution of events",
                                   c("Maximum",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 4, 
                       numericInput("DR_GJFM_puiss_ratio", "Ratio", 1)
                )
              ),
              
              fluidRow(
                id = "DR_GJFM_puiss_data_sujets_FR",
                
                column(width = 4),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DR_GJFM_puiss_repartition_events == 'Maximum' || input.DR_GJFM_puiss_repartition_events == 'Poisson'",
                         numericInput("DR_GJFM_puiss_nbr_events_par_grp", "Number of expected events per patient", 5)),
                       
                       conditionalPanel(
                         condition = "input.DR_GJFM_puiss_repartition_events == 'Uniform'",
                         numericInput("DR_GJFM_puiss_nbr_events_par_grp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_GJFM_puiss_nbr_events_par_grp_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 4)
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_GJFM_puiss_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_puiss_info_test",
                  
                  selectInput("DR_GJFM_puiss_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_GJFM_puiss_typIerror", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_GJFM_puiss_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_puiss_fisher",
                  
                  numericInput("DR_GJFM_puiss_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
                
                tags$br(),
                
                h4("Hazard Ratio", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_puiss_test_beta",
                  
                  selectInput("DR_GJFM_puiss_method", "Method",
                              c("joint",  "betaRtest", "betaDtest")),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_betaR0", "Beta values for recurrent events under H0(logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_betaRA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75)),
                  ),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_betaD0", "Beta values for terminal events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_betaDA", "Beta values for terminal events under HA (logarithm of)", value = 0.85)),
                  )
                )
              ),
              
              column(
                width = 6,
                id = "DR_GJFM_puiss_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_puiss_data_essai_div",
                  
                  selectInput("DR_GJFM_puiss_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_GJFM_puiss_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_GJFM_puiss_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_GJFM_puiss_periode_suivi", "Follow-up period", 30),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_median_rec_h0", "Median time of recurrent events under H0", 10)),
                    
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_median_term_h0", "Median time of terminal events under H0", 25))
                  ),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_puiss_weibullR", "Shape parameter of Weibull for recurrent events", 1)),
                    
                    column(width = 6, 
                           numericInput("DR_GJFM_puiss_weibullD", "Shape parameter of Weibull for terminal events", 1))
                  ),
                  
                  numericInput("DR_GJFM_puiss_theta", "Variability of the baseline risk at the cluster level", 0.05),
                  
                  numericInput("DR_GJFM_puiss_eta", "Variance of inter-recurrence", 0.01)
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_GJFM_lance_puissance",
              
              actionButton(inputId="DR_GJFM_lance_puissance", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DR_GJFM_lance_puissance",
              
              fluidRow(
                id= "DR_GJFM_puiss_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_GJFM_resultat_puissance", 
                         htmlOutput(outputId = "DR_GJFM_puiss_valeur_res"))
                )
              )
            )
          ),
            
          
          #### Help=========================================================================================
          tabPanel(
            "Help",
              
            h3("Help", id = "sous_titre"),
              
            tags$br(),
            
            div(
              id="DR_tab_help",
              choixTabHelp("DR_help")
            )
          )
        )
      ), 

      ### Calcul de NSN======================================================================================
      tabItem(
        tabName = "DR_calc_NSN",
        
        tags$h2("Recurring Data", id = "titre_page"),
        
        tabsetPanel(
          
          #### SFM==========================================================================================
          tabPanel(
            "Shared Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_SFM_NSN_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_SFM_NSN_data_sujets_div",
              
              fluidRow(
                id = "DR_SFM_NSN_data_sujets_FR",
                
                column(width = 4,
                       selectInput("DR_SFM_NSN_type_data", "Data type",
                                   c("rec_event"))
                ),
                
                column(width = 4,
                       selectInput("DR_SFM_NSN_repartition_events", "Distribution of events",
                                   c("Fixed",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 4, 
                       numericInput("DR_SFM_NSN_ratio", "Ratio", 1)
                )
              ),
              
              fluidRow(
                id = "DR_SFM_NSN_data_sujets_FR",
                
                column(width = 4),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DR_SFM_NSN_repartition_events == 'Fixed' || input.DR_SFM_NSN_repartition_events == 'Poisson'",
                         numericInput("DR_SFM_NSN_nbr_events_par_grp", "Number of expected events", 15)),
                       
                       conditionalPanel(
                         condition = "input.DR_SFM_NSN_repartition_events == 'Uniform'",
                         numericInput("DR_SFM_NSN_nbr_events_par_grp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_SFM_NSN_nbr_events_par_grp_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 4)
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_SFM_NSN_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_SFM_NSN_info_test",
                  
                  numericInput("DR_SFM_NSN_puissance", "Power", 0.8),
                  
                  selectInput("DR_SFM_NSN_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_SFM_NSN_alpha", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_SFM_NSN_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_SFM_NSN_fisher",
                  
                  numericInput("DR_SFM_NSN_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
              ),
              
              column(
                width = 6,
                id = "DR_SFM_NSN_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_SFM_NSN_data_essai_div",
                  
                  selectInput("DR_SFM_NSN_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_SFM_NSN_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_SFM_NSN_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_SFM_NSN_periode_suivi", "Follow-up period", 30),
                  
                  numericInput("DR_SFM_NSN_median_survie_h0", "Median survival time under H0", 12),
                  
                  selectInput("DR_SFM_NSN_distrib_death", "Distribution of death times",
                              c("Uniform",  "Exponential")),
                  
                  conditionalPanel(
                    condition = "input.DR_SFM_NSN_distrib_death == 'Uniform'",
                    fluidRow(
                      column(width = 6,
                             numericInput("DR_SFM_NSN_cencor_time_death_unif_a", "Parameter a of a uniform distribution", 5)),
                      column(width = 6,
                             numericInput("DR_SFM_NSN_cencor_time_death_unif_b", "Parameter b of a uniform distribution", 15))
                    )),
                  
                  conditionalPanel(
                    condition = "input.DR_SFM_NSN_distrib_death == 'Exponential'",
                    numericInput("DR_SFM_NSN_cencor_time_death", "Censor time for death (parameter λ)", 15)),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_SFM_NSN_beta0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_SFM_NSN_betaA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75))
                  ),
                  
                  numericInput("DR_SFM_NSN_param_weibull", "Shape parameter of Weibull", 1),
                  
                  numericInput("DR_SFM_NSN_theta", "Variability of the baseline risk at the individual level", 0.25)
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_SFM_lance_NSN",
              
              actionButton(inputId="DR_SFM_lance_NSN", label="Compute", class="btn btn-primary btn-lg", style="color: white;"),
            ),
            
            conditionalPanel(
              condition = "input.DR_SFM_lance_NSN",
              
              fluidRow(
                id= "DR_SFM_NSN_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_SFM_resultat_NSN",
                         htmlOutput(outputId = "DR_SFM_NSN_valeur_res"))
                )
              )
            )
          ),
          
          
          #### NFM==========================================================================================
          tabPanel(
            "Nested Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_NFM_NSN_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_NFM_NSN_data_sujets_div",
              
              fluidRow(
                id = "DR_NFM_NSN_data_sujets_FR",
                
                column(width = 3,
                       selectInput("DR_NFM_NSN_type_data", "Data type",
                                   c("rec_event1", "rec_event2"))
                ),
                
                column(width = 3, 
                       numericInput("DR_NFM_NSN_ratio", "Ratio", 1)
                ),
                
                column(width = 3,
                       selectInput("DR_NFM_NSN_repartition_subgroups", "Distribution of subgroups considered",
                                   c("Fixed",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 3, 
                       selectInput("DR_NFM_NSN_repartition_events", "Distribution of events per subgroups",
                                   c("Fixed",  "Uniform", "Poisson"))
                )
              ),
              
              fluidRow(
                id = "DR_NFM_NSN_data_sujets_FR",
                
                column(width = 3),
                
                column(width = 3),
                
                column(width = 3,
                       conditionalPanel(
                         condition = "input.DR_NFM_NSN_repartition_subgroups == 'Fixed' || input.DR_NFM_NSN_repartition_subgroups == 'Poisson'",
                         numericInput("DR_NFM_NSN_nbr_subgroups", "Number of subgroups", 10)),
                       
                       conditionalPanel(
                         condition = "input.DR_NFM_NSN_repartition_subgroups == 'Uniform'",
                         numericInput("DR_NFM_NSN_nbr_subgroups_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_NFM_NSN_nbr_subgroups_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 3,
                       conditionalPanel(
                         condition = "input.DR_NFM_NSN_repartition_events == 'Fixed' || input.DR_NFM_NSN_repartition_events == 'Poisson'",
                         numericInput("DR_NFM_NSN_nbr_events_par_subgrp", "Number of expected events per subgroup", 15)),
                       
                       conditionalPanel(
                         condition = "input.DR_NFM_NSN_repartition_events == 'Uniform'",
                         numericInput("DR_NFM_NSN_nbr_events_par_subgrp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_NFM_NSN_nbr_events_par_subgrp_unif_b", "Parameter b of a uniform distribution", 5))
                )
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_NFM_NSN_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_NFM_NSN_info_test",
                  
                  numericInput("DR_NFM_NSN_puissance", "Power", 0.8),
                  
                  selectInput("DR_NFM_NSN_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_NFM_NSN_alpha", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_NFM_NSN_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_NFM_NSN_fisher",
                  
                  numericInput("DR_NFM_NSN_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
              ),
              
              column(
                width = 6,
                id = "DR_NFM_NSN_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_NFM_NSN_data_essai_div",
                  
                  selectInput("DR_NFM_NSN_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_NFM_NSN_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_NFM_NSN_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_NFM_NSN_periode_suivi", "Follow-up period", 30),
                  
                  numericInput("DR_NFM_NSN_median_survie_h0", "Median survival time under H0", 12),
                  
                  selectInput("DR_NFM_NSN_distrib_death", "Distribution of death times",
                              c("Uniform",  "Exponential")),
                  
                  conditionalPanel(
                    condition = "input.DR_NFM_NSN_distrib_death == 'Uniform'",
                    fluidRow(
                      column(width = 6,
                             numericInput("DR_NFM_NSN_cencor_time_death_unif_a", "Parameter a of a uniform distribution", 5)),
                      column(width = 6,
                             numericInput("DR_NFM_NSN_cencor_time_death_unif_b", "Parameter b of a uniform distribution", 15))
                    )),
                  
                  conditionalPanel(
                    condition = "input.DR_NFM_NSN_distrib_death == 'Exponential'",
                    numericInput("DR_NFM_NSN_cencor_time_death", "Censor time for death (parameter λ)", 15)),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_NFM_NSN_beta0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                  
                    column(width = 6,
                           numericInput("DR_NFM_NSN_betaA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75))
                  ),
                  
                  numericInput("DR_NFM_NSN_param_weibull", "Shape parameter of Weibull", 1),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_NFM_NSN_theta", "Variability of the baseline risk at the cluster level", 0.25)),
                    
                    column(width = 6,
                           numericInput("DR_NFM_NSN_eta", "Variability of the baseline risk at the subcluster level", 0.5))
                  )
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_NFM_lance_NSN",
              
              actionButton(inputId="DR_NFM_lance_NSN", label="Compute", class="btn btn-primary btn-lg", style="color: white;"),
            ),
            
            conditionalPanel(
              condition = "input.DR_NFM_lance_NSN",
              
              fluidRow(
                id= "DR_NFM_NSN_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_NFM_resultat_NSN",
                         htmlOutput(outputId = "DR_NFM_NSN_valeur_res"))
                )
              )
            )
          ),
          
          
          #### JFM==========================================================================================
          tabPanel(
            "Joint Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_JFM_NSN_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_JFM_NSN_data_sujets_div",
              
              fluidRow(
                id = "DR_JFM_NSN_data_sujets_FR",
                
                column(width = 4,
                       selectInput("DR_JFM_NSN_repartition_events", "Distribution of events",
                                   c("Maximum",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DR_JFM_NSN_repartition_events == 'Maximum' || input.DR_JFM_NSN_repartition_events == 'Poisson'",
                         numericInput("DR_JFM_NSN_nbr_events_par_grp", "Number of expected events per patient", 3)),
                       
                       conditionalPanel(
                         condition = "input.DR_JFM_NSN_repartition_events == 'Uniform'",
                         numericInput("DR_JFM_NSN_nbr_events_par_grp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_JFM_NSN_nbr_events_par_grp_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 4, 
                       numericInput("DR_JFM_NSN_ratio", "Ratio", 1)
                )
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_JFM_NSN_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_NSN_info_test",
                  
                  numericInput("DR_JFM_NSN_puissance", "Power", 0.8),
                  
                  selectInput("DR_JFM_NSN_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_JFM_NSN_typIerror", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_JFM_NSN_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_NSN_fisher",
                  
                  numericInput("DR_JFM_NSN_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
                
                tags$br(),
                
                h4("Hazard Ratio", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_NSN_test_beta",
                  
                  selectInput("DR_JFM_NSN_method", "Method",
                              c("joint",  "betaRtest", "betaDtest")),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_NSN_betaR0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_JFM_NSN_betaRA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75))
                  ),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_NSN_betaD0", "Beta values for terminal events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_JFM_NSN_betaDA", "Beta values for terminal events under HA (logarithm of)", value = 0.85))
                  )
                )
              ),
              
              column(
                width = 6,
                id = "DR_JFM_NSN_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_JFM_NSN_data_essai_div",
                  
                  selectInput("DR_JFM_NSN_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_JFM_NSN_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_JFM_NSN_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_JFM_NSN_periode_suivi", "Follow-up period", 30),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_NSN_median_rec_h0", "Median time of recurrent events under H0", 10)),
                    
                    column(width = 6,
                           numericInput("DR_JFM_NSN_median_term_h0", "Median time of terminal events under H0", 15))
                  ),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_JFM_NSN_weibullR", "Shape parameter of Weibull for recurrent events", 1)),
                    
                    column(width = 6, 
                           numericInput("DR_JFM_NSN_weibullD", "Shape parameter of Weibull for terminal events", 1))
                  ),
                  
                  numericInput("DR_JFM_NSN_theta", "Variability of the baseline risk at the cluster level", 0.25),
                  
                  numericInput("DR_JFM_NSN_alpha", "Association between recurrent and terminal events", 0)
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_JFM_lance_NSN",
              
              actionButton(inputId="DR_JFM_lance_NSN", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DR_JFM_lance_NSN",
              
              fluidRow(
                id= "DR_JFM_NSN_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_JFM_resultat_NSN", 
                         htmlOutput(outputId = "DR_JFM_NSN_valeur_res"))
                )
              )
            )
          ),
          
          
          #### GJFM=========================================================================================
          tabPanel(
            "General Joint Frailty Model",
            
            h3("Power calculation parameters", id = "sous_titre"),
            
            tags$br(),
            
            div(id = "seed",
                numericInput("DR_GJFM_NSN_seed", label = "Seed", 105795)
            ),
            
            tags$br(),
            tags$br(),
            
            div(
              id="DR_GJFM_NSN_data_sujets_div",
              
              fluidRow(
                id = "DR_GJFM_NSN_data_sujets_FR",
                
                column(width = 4,
                       selectInput("DR_GJFM_NSN_repartition_events", "Distribution of events",
                                   c("Maximum",  "Uniform", "Poisson")),
                       
                ),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DR_GJFM_NSN_repartition_events == 'Maximum' || input.DR_GJFM_NSN_repartition_events == 'Poisson'",
                         numericInput("DR_GJFM_NSN_nbr_events_par_grp", "Number of expected events per patient", 3)),
                       
                       conditionalPanel(
                         condition = "input.DR_GJFM_NSN_repartition_events == 'Uniform'",
                         numericInput("DR_GJFM_NSN_nbr_events_par_grp_unif_a", "Parameter a of a uniform distribution", 1),
                         numericInput("DR_GJFM_NSN_nbr_events_par_grp_unif_b", "Parameter b of a uniform distribution", 5))
                ),
                
                column(width = 4, 
                       numericInput("DR_GJFM_NSN_ratio", "Ratio", 1)
                )
              ),
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DR_GJFM_NSN_info_test_simu_FR",
                
                h4("Statistic", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_NSN_info_test",
                  
                  numericInput("DR_GJFM_NSN_puissance", "Power", 0.8),
                  
                  selectInput("DR_GJFM_NSN_type_test", "Type of test",
                              c("2-sided",  "1-sided")),
                  
                  numericInput("DR_GJFM_NSN_typIerror", "Type I error", 0.05, min=0, max=0.2),
                  
                  selectInput("DR_GJFM_NSN_stat_test", "Statistic",
                              c("Wald"))
                ),
                
                tags$br(),
                
                h4("Fisher matrix", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_NSN_fisher",
                  
                  numericInput("DR_GJFM_NSN_nbr_echantillon_MC", "Number of Monte Carlo runs", 10000)
                ),
                
                tags$br(),
                
                h4("Hazard Ratio", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_NSN_test_beta",
                  
                  selectInput("DR_GJFM_NSN_method", "Method",
                              c("joint",  "betaRtest", "betaDtest")),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_betaR0", "Beta values for recurrent events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_betaRA", "Beta values for recurrent events under HA (logarithm of)", value = 0.75)),
                  ),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_betaD0", "Beta values for terminal events under H0 (logarithm of)", value = 1)),
                    
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_betaDA", "Beta values for terminal events under HA (logarithm of)", value = 0.85)),
                  )
                )
              ),
              
              column(
                width = 6,
                id = "DR_GJFM_NSN_data_essai_col",
                
                h4("About the trial", id = "sous_titre_sous_partie"),
                
                div(
                  id="DR_GJFM_NSN_data_essai_div",
                  
                  selectInput("DR_GJFM_NSN_timescale", "Timescale",
                              c("Gap")),
                  
                  selectInput("DR_GJFM_NSN_type_suivi", "Type of follow-up",
                              c("UptoEnd",  "Fixed")),
                  tags$br(),
                  
                  p("Define periods with the same unit for all periods !"),
                  p("Default values are in months."),
                  
                  numericInput("DR_GJFM_NSN_periode_inclusion", "Inclusion period", 24),
                  
                  numericInput("DR_GJFM_NSN_periode_suivi", "Follow-up period", 30),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_median_rec_h0", "Median time of recurrent events under H0", 10)),
                    
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_median_term_h0", "Median time of terminal events under H0", 15))
                  ),
                  
                  tags$br(),
                  tags$br(),
                  
                  fluidRow(
                    column(width = 6,
                           numericInput("DR_GJFM_NSN_weibullR", "Shape parameter of Weibull for recurrent events", 1)),
                    
                    column(width = 6, 
                           numericInput("DR_GJFM_NSN_weibullD", "Shape parameter of Weibull for terminal events", 1))
                  ),
                  
                  numericInput("DR_GJFM_NSN_theta", "Variability of the baseline risk at the cluster level", 0.25),
                  
                  numericInput("DR_GJFM_NSN_eta", "Variance of inter-recurrence", 0.1)
                )
              )
            ),
            
            tags$br(),
            
            div(
              id = "DR_GJFM_lance_NSN",
              
              actionButton(inputId="DR_GJFM_lance_NSN", label="Compute", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DR_GJFM_lance_NSN",
              
              fluidRow(
                id= "DR_GJFM_NSN_res_FR",
                
                h3(id="DR_resultat_titre", "Results"),
                
                tags$br(),
                
                div(
                  column(11, id="DR_GJFM_resultat_NSN", 
                         htmlOutput(outputId = "DR_GJFM_NSN_valeur_res"))
                )
              )
            )
          ),
          
          
          #### Help=========================================================================================
          tabPanel(
            "Help",
            
            h3("Help", id = "sous_titre"),
            
            tags$br(),
            
            div(
              id="DR_tab_help",
              choixTabHelp("DR_help")
            )
          )
        )
      )#end tabItem de données récurrentes

    ) #end de tabItems
  ) #end de dashboardBody
) #end dashboardPage


##==========================================================================================================#
# Fin de code ###############################################################################################
##==========================================================================================================#













































