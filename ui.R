#---------------------------------------------------------------------------------------------------#
# Working directory----------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#

setwd("P:/Appli NSN/Appli_ui_server")
#setwd("C:/Jade/Bergonié/Appli NSN")



#---------------------------------------------------------------------------------------------------#
# Lexique--------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
# DG = Données groupées
# BSD = Biomarker strategy design
# DR = Données récurrentes



#---------------------------------------------------------------------------------------------------#
# Sources--------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#

source("Y:/Jade/Programmation/Rcode_AddFM.R")
#source("C:/Jade/Bergonié/Appli NSN/Rcode_AddFM.R")




#---------------------------------------------------------------------------------------------------#
# Librairies-----------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#

library(shiny)

library(shinydashboard)
library(shinydashboardPlus)

library(devtools)

library("DT")

library(shinyjs)




# Début de code #############################################################################################

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
        menuItem("Introduction", tabName = "introduction", icon = icon("info")),
        menuItem("Grouped Data", tabName = "donnees_groupees", icon = icon("th"),
                 menuSubItem("Power calculation", tabName = "calc_puissance"),
                 menuSubItem("NSN calculation", tabName = "calc_NSN")),
        menuItem("Biomarker strategy Design", tabName = "biomark_strat_design", icon = icon("list")),
        menuItem("Recurring Data", tabName = "donnees_recurrentes", icon = icon("chart-bar"))
      )
    ),
                     
#########################################################################################################Body
  dashboardBody(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    tabItems(
##----------------------------------------------------------------------------------------------------------#
## Introduction----------------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
      tabItem(
        tabName = "introduction",
        tags$h2("Introduction", id = "titre_page"),
        tags$h3("Methods for estimating randomized trial sizes in oncology in the presence of survival data and heterogeneous and heterogeneous populations", id = "intro_sous_titre"),
        
        tags$br(),
        
        fluidRow(
          id = "intro_FR",
          
          h3("Grouped Data", id = "intro_titre"),
          tags$br(),
          p(id = "intro_texte_descr", "Text and links"),
          
          tags$br(),
          tags$br(),
          
          h3("Biomarker strategy Design", id = "intro_titre"),
          tags$br(),
          p(id = "intro_texte_descr", "Text and links"),
          
          tags$br(),
          tags$br(),
          
          h3("Recurring Data", id = "intro_titre"),
          tags$br(),
          p(id = "intro_texte_descr", "Text and links")
        )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Données groupées------------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
                         
### Calcul de puissance======================================================================================
                         
      tabItem(
        tabName = "calc_puissance",
        
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
                       selectInput("DG_puiss_repartition_par_groupe", "Distribution by groupe",
                                   c("Fixed",  "Unif")),
                       
                       conditionalPanel(
                         condition = "input.DG_puiss_repartition_par_groupe == 'Fixed'",
                         numericInput("DG_puiss_nbr_sujet_par_grp", "Number of subjets per group", 15)),
                       
                       conditionalPanel(
                         condition = "input.DG_puiss_repartition_par_groupe == 'Unif'",
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
                
              actionButton(inputId="DG_lance_puissance", label="Calculate", class="btn btn-primary btn-lg", style="color: white;")
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
            
          tabPanel(
            "Help",
              
            h3("Help", id = "sous_titre"),
              
            tags$br(),
              
            tags$table(
              
              tags$tr(
                tags$th("Bootstrap"),
                tags$td("Logical parameter for running a Bootstrap method to calculate the confidence interval for power estimates. Default value is FALSE (box unchecked).")
              ),
              
              tags$tr(
                tags$th("Correlation between both random effects"),
                tags$td("Correlation coefficient between the two fragilities. Default value is 0.5.")
              ),
              
              tags$tr(
                tags$th("Distribution by groupe"),
                tags$td("Distribution of subjects within groups :
                            - Fixed: fixed number of subjects for each group
                            - Unif: distribution of subjects according to a uniform distribution of parameters a and b")
              ),
              
              tags$tr(
                tags$th("Follow-up period"),
                tags$td("Duration of follow-up (same unit as the median).")
              ),
                
              tags$tr(
                tags$th("Hazard Ratio (HR)"),
                tags$td("the hazard ratio or ratio of median survival times.")
              ),
              
              tags$tr(
                tags$th("Inclusion period"),
                tags$td("Period allocated to patient inclusion (same unit as the median).")
              ),
              
              tags$tr(
                tags$th("Median survival time under H0"),
                tags$td("The survival median under null hypothesis.")
              ),
              
              tags$tr(
                tags$th("Number of bootstrap resamples"),
                tags$td("Default 1000.")
              ),
              
              tags$tr(
                tags$th("Number of groups"),
                tags$td("Number of groups to calculate test power. Performs power estimation, when specified.")
              ),
              
              tags$tr(
                tags$th("Number of Monte Carlo runs"),
                tags$td("Number of runs launched to approximate the Fisher matrix by simulations.")
              ),
              
              tags$tr(
                tags$th("Number of subjects per group"),
                tags$td("Number of patients expected in each group.")
              ),
              
              tags$tr(
                tags$th("Ratio"),
                tags$td("andomization ratio in favor of the experimental arm. Default value is 1.")
              ),
              
              tags$tr(
                tags$th("Seed"),
                tags$td("Seed for reproducing estimates.")
              ),
              
              tags$tr(
                tags$th("Shape parameter of Weibull"),
                tags$td("Shape parameter of the Weibull distribution. Defaults to 1, assuming exponentially distributed survival times.")
              ),
              
              tags$tr(
                tags$th("Statistic"),
                tags$td("The test used to evaluate whether there is a significant clinical effect between treatment arms")
              ),
              
              tags$tr(
                tags$th("Type I error"),
                tags$td("Type I error rate or significance level. Default 0.05.")
              ),
              
              tags$tr(
                tags$th("Type of follow-up"),
                tags$td("Defines how patients are monitored:
                            - UptoEnd: from inclusion to end of study
                            - Fixed: each patient is followed for the same length of time, regardless of inclusion date")
              ),
              
              tags$tr(
                tags$th("Type of test"),
                tags$td("Allows to specify the direction of the test:
                            - 2-sided for two-sided 
                            - 1-sided for unilateral")
              ),
              
              tags$tr(
                tags$th("Variance of treatment effect"),
                tags$td("Variance of random slope (random effect associated with treatment effect between groups). Default value is 0.1.")
              ),
              
              tags$tr(
                tags$th("Variance of the baseline risk"),
                tags$td("Random intercept variance (random effect associated with the basis risk function). Default value is 0.1.")
              )
            )
          )
        )
      ),
                         
                         
### Calcul du NSN============================================================================================
                         
      tabItem(
        tabName = "calc_NSN",
          
        tags$h2("Grouped Data", id = "titre_page" ),
          
        tabsetPanel(
          tabPanel(
            "Settings",
              
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
                       selectInput("DG_NSN_repartition_par_groupe", "Distribution by group",
                                   c("Fixed",  "Unif"))),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DG_NSN_repartition_par_groupe == 'Fixed'",
                          numericInput("DG_NSN_nbr_sujet_par_grp", "Number of subjects per group", 15)),
                         
                        conditionalPanel(
                          condition = "input.DG_NSN_repartition_par_groupe == 'Unif'",
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
                
              actionButton(inputId="DG_lance_NSN", label="Calculate", class="btn btn-primary btn-lg", style="color: white;")
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
            
          tabPanel(
            "Help",
              
            h3("Help", id = "sous_titre"),
              
            tags$br(),
              
            tags$table(
              
              tags$tr(
                tags$th("Bootstrap"),
                tags$td("Logical parameter for running a Bootstrap method to calculate the confidence interval for power estimates. Default value is FALSE (box unchecked).")
              ),
              
              tags$tr(
                tags$th("Correlation between both random effects"),
                tags$td("Correlation coefficient between the two fragilities. Default value is 0.5.")
              ),
              
              tags$tr(
                tags$th("Distribution by groupe"),
                tags$td("Distribution of subjects within groups :
                            - Fixed: fixed number of subjects for each group
                            - Unif: distribution of subjects according to a uniform distribution of parameters a and b")
              ),
              
              tags$tr(
                tags$th("Follow-up period"),
                tags$td("Duration of follow-up (same unit as the median).")
              ),
              
              tags$tr(
                tags$th("Hazard Ratio (HR)"),
                tags$td("the hazard ratio or ratio of median survival times.")
              ),
              
              tags$tr(
                tags$th("Inclusion period"),
                tags$td("Period allocated to patient inclusion (same unit as the median).")
              ),
              
              tags$tr(
                tags$th("Median survival time under H0"),
                tags$td("The survival median under null hypothesis.")
              ),
              
              tags$tr(
                tags$th("Number of bootstrap resamples"),
                tags$td("Default 1000.")
              ),
              
              tags$tr(
                tags$th("Number of Monte Carlo runs"),
                tags$td("Number of runs launched to approximate the Fisher matrix by simulations.")
              ),
              
              tags$tr(
                tags$th("Number of subjects per group"),
                tags$td("Number of patients expected in each group.")
              ),
              
              tags$tr(
                tags$th("Power"),
                tags$td("The probability of detecting the predefined significant effect (HR) and is defined as 1-type II error.")
              ),
              
              tags$tr(
                tags$th("Ratio"),
                tags$td("andomization ratio in favor of the experimental arm. Default value is 1.")
              ),
              
              tags$tr(
                tags$th("Seed"),
                tags$td("Seed for reproducing estimates.")
              ),
              
              tags$tr(
                tags$th("Shape parameter of Weibull"),
                tags$td("Shape parameter of the Weibull distribution. Defaults to 1, assuming exponentially distributed survival times.")
              ),
              
              tags$tr(
                tags$th("Statistic"),
                tags$td("The test used to evaluate whether there is a significant clinical effect between treatment arms")
              ),
              
              tags$tr(
                tags$th("Type I error"),
                tags$td("Type I error rate or significance level. Default 0.05.")
              ),
              
              tags$tr(
                tags$th("Type of follow-up"),
                tags$td("Defines how patients are monitored:
                            - UptoEnd: from inclusion to end of study
                            - Fixed: each patient is followed for the same length of time, regardless of inclusion date")
              ),
              
              tags$tr(
                tags$th("Type of test"),
                tags$td("Allows to specify the direction of the test:
                            - 2-sided for two-sided 
                            - 1-sided for unilateral")
              ),
              
              tags$tr(
                tags$th("Variance of treatment effect"),
                tags$td("Variance of random slope (random effect associated with treatment effect between groups). Default value is 0.1.")
              ),
              
              tags$tr(
                tags$th("Variance of the baseline risk"),
                tags$td("Random intercept variance (random effect associated with the basis risk function). Default value is 0.1.")
              )
            )
          )
        )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Biomarker strategy Design---------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
      tabItem(
        tabName = "biomark_strat_design",
          
        tags$h2("Biomarker strategy Design", id = "titre_page")
        
          # tabsetPanel(
          #   tabPanel(
          #     
          #   )
          # )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Données récurrentes---------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
      tabItem(
        tabName = "donnees_recurrentes",
        tags$h2("Recurring Data", id = "titre_page")
        
          # tabsetPanel(
          #   tabPanel(
          #     
          #   )
          # )
        
      ) #end tabItem de données récurrentes
    ) #end de tabItems
  ) #end de dashboardBody
) #end dashboardPage
