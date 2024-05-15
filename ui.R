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
        menuItem("Données Groupées", tabName = "donnees_groupees", icon = icon("th"),
                 menuSubItem("Calcul de puissance", tabName = "calc_puissance"),
                 menuSubItem("Calcul de taille d'échantillon", tabName = "calc_NSN")),
        menuItem("Biomarker strategy Design", tabName = "biomark_strat_design", icon = icon("list")),
        menuItem("Données récurrentes", tabName = "donnees_recurrentes", icon = icon("chart-bar"))
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
        
        tags$br(),
        
        fluidRow(
          id = "intro_FR",
          
          h3("Données groupées", id = "intro_titre"),
          tags$br(),
          p(id = "intro_texte_descr", "Texte et mettre liens"),
          
          tags$br(),
          tags$br(),
          
          h3("Biomarker strategy Design", id = "intro_titre"),
          tags$br(),
          p(id = "intro_texte_descr", "Texte et mettre liens"),
          
          tags$br(),
          tags$br(),
          
          h3("Données récurrentes", id = "intro_titre"),
          tags$br(),
          p(id = "intro_texte_descr", "Texte et mettre liens")
        )
      ),
                         
##----------------------------------------------------------------------------------------------------------#
## Données groupées------------------------------------------------------------------------------------------
##----------------------------------------------------------------------------------------------------------#
                         
### Calcul de puissance======================================================================================
                         
      tabItem(
        tabName = "calc_puissance",
        
        tags$h2("Données Groupées", id = "titre_page"),
        
        tabsetPanel(
          tabPanel(
            "Paramétrage",
            
            h3("Paramètres du calcul du la puissance", id = "sous_titre"),
            
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
                
                column(width = 4, numericInput("DG_puiss_nbr_groupe", "Nombre de groupe", 10)),
                
                column(width = 4,
                       selectInput("DG_puiss_repartition_par_groupe", "Répartition par groupe",
                                   c("Fixed",  "Unif")),
                       
                       conditionalPanel(
                         condition = "input.DG_puiss_repartition_par_groupe == 'Fixed'",
                         numericInput("DG_puiss_nbr_sujet_par_grp", "Nombre de sujet par groupe", 15)),
                       
                       conditionalPanel(
                         condition = "input.DG_puiss_repartition_par_groupe == 'Unif'",
                         numericInput("DG_puiss_unif_a", "Nombre de sujet par groupe", 1),
                         numericInput("DG_puiss_unif_b", "Nombre de sujet par groupe", 2))
                        ),
                
                column(width = 4, numericInput("DG_puiss_ratio", "Ratio (n_e/n_c)", 1))
              )
            ),
            
            tags$br(),
            tags$br(),
            
            fluidRow(
              column(
                width = 6, 
                id = "DG_puiss_info_test_simu_FR",
                  
                h4("Test statistique", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_puiss_info_test",
                    
                  selectInput("DG_puiss_type_test", "Type de test",
                              c("2-sided",  "1-sided")),
                    
                  numericInput("DG_puiss_alpha", "Erreur de type I", 0.05, min=0, max=0.2),
                    
                  selectInput("DG_puiss_stat_test", "Statistique de test",
                                c("Wald")),
                    
                  numericInput("DG_puiss_nbr_echantillon_MC", "Nombre de simulmation de Monte Carlo", 10000)
                ),
                  
                tags$br(),
                  
                h4("Simulation", id = "sous_titre_sous_partie"),
                    
                div(
                  id="DG_puiss_simulation",
                      
                  checkboxInput(inputId = "DG_puiss_bootstrap", label = "Bootstrap", value = FALSE),
                      
                  numericInput("DG_puiss_nboot", "Nboot", 1000)
                )
              ),
                
              column(
                width = 6,
                id = "DG_puiss_data_essai_col",
                  
                h4("Info à propos de l'essai", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_puiss_data_essai_div",
                    
                  selectInput("DG_puiss_type_suivi", "Type de suivi",
                                c("UptoEnd",  "Fixed")),
                  tags$br(),
                    
                  p("Si on définit les périodes en mois alors respecter cette unité pour toutes les périodes entrées !"),
                  p("Les valeurs par défaut sont en mois."),
                    
                  numericInput("DG_puiss_periode_inclusion", "Période d'inclusion", 24),
                    
                  numericInput("DG_puiss_periode_suivi", "Période de suivi", 30),
                    
                  numericInput("DG_puiss_median_survie_h0", "Médiane de survie sous H0", 12),
                    
                  tags$br(),
                  tags$br(),
                    
                  numericInput("DG_puiss_HR", "Hazard Ratio", value= 0.75, min=0 , max=1),
                    
                  numericInput("DG_puiss_param_weibull", "Paramètre de Weibull", 1),
                    
                  numericInput("DG_puiss_variance_0", "Variance du risque de base intergroupe", 0.1),
                    
                  numericInput("DG_puiss_variance_1", "Variance d'effet du traitement intergroupe", 0.1),
                    
                  numericInput("DG_puiss_correlation_effet", "Corrélation entre les effets aléatoires", 0.5, min=-1, max=1)
                )
              )
            ),
              
            tags$br(),
              
            div(
              id = "DG_lance_puissance",
                
              actionButton(inputId="DG_lance_puissance", label="Calculer", class="btn btn-primary btn-lg", style="color: white;")
            ),
            
            conditionalPanel(
              condition = "input.DG_lance_puissance",
              
              fluidRow(
                id= "DG_puiss_res_FR",
                
                h3(id="DG_resultat_titre", "Résultats"),
                
                tags$br(),
                
                div(
                  column(11, id="DG_resultat_puissance", htmlOutput(outputId = "DG_puiss_valeur_res"))
                )
              )
            )
          ),
            
          tabPanel(
            "Aide",
              
            h3("Aide", id = "sous_titre"),
              
            tags$br(),
              
            tags$table(
              
              tags$tr(
                tags$th("Bootstrap"),
                tags$td("Paramètre logique pour exécuter une méthode Bootstrap afin de calculer l’intervalle de confiance pour les estimations du NSN ou de puissance. La valeur par défaut est FALSE (case non cochée).")
              ),
              
              tags$tr(
                tags$th("Corrélation entre effets aléatoires"),
                tags$td("Coefficient de corrélation entre les deux fragilités. La valeur par défaut est 0,5.")
              ),
              
              tags$tr(
                tags$th("Erreur de type I"),
                tags$td("Taux d’erreur de type I ou niveau de signification. Défini à 0,05 par défaut.")
              ),
                
              tags$tr(
                tags$th("Hazard Ratio (HR)"),
                tags$td("Hazard ratio ou rapport des temps de survie médians (Contrôle sur Expérimental).")
              ),
              
              tags$tr(
                tags$th("Médiane attendue sous H0"),
                tags$td("Indique le délai attendu dans lequel la moitié des individus d'unéchantillon sont décédés, l'autre moitié étant encore vivante sousl'hypothèse H0.")
              ),
              
              tags$tr(
                tags$th("Nboot"),
                tags$td("Nombre de rééchantillons bootstrap. Défini à 1000 par défaut.")
              ),
              
              tags$tr(
                tags$th("Nombre de groupe"),
                tags$td("Nombre de groupes prévus pour calculer la puissance de l’essai. Réalise une estimation de puissance, quand spécifié.")
              ),
              
              tags$tr(
                tags$th("Nombre de simulation de Monte Carlo"),
                tags$td("Nombre d’exécutions lancées pour l’approximation de la matrice de Fisher par simulations.")
              ),
              
              tags$tr(
                tags$th("Nombre de sujet par groupe"),
                tags$td("Nombre de patients attendus dans chaque groupe.")
              ),
              
              tags$tr(
                tags$th("Paramètre de Weibull"),
                tags$td("Paramètre de forme de la distribution de Weibull. Défini par défaut à 1 supposant des temps de survie distribués de manière exponentielle.")
              ),
              
              tags$tr(
                tags$th("Période d'inclusion"),
                tags$td("Caractérise la période allouée à l'inclusion des patients (en jours, en mois ou en années")
              ),
              
              tags$tr(
                tags$th("Période de suivi"),
                tags$td("Caractérise la durée pour laquelle les patient ont été suivi (en jours, en mois ou en années")
              ),
              
              tags$tr(
                tags$th("Ratio"),
                tags$td("Ratio de randomisation en faveur du bras expérimental. La valeur par défaut est 1")
              ),
              
              tags$tr(
                tags$th("Répartition par groupe"),
                tags$td("Répartition des sujets au sein des groupes :
                            - Fixed : nombre fixe de sujets pour chaque groupe
                            - Unif: répartition des sujets suivant une distribution uniforme de paramètres a et b")
              ),
              
              tags$tr(
                tags$th("Seed"),
                tags$td("Graine permettant de reproduire les estimations")
              ),
              
              tags$tr(
                tags$th("Statistique de test"),
                tags$td("Statistique utilisée pour l’estimation. Seule la statistique ”Wald” est actuellement disponible. Les tests du score et du logrank seront prochainement implémentés")
              ),
              
              tags$tr(
                tags$th("Type de suivi"),
                tags$td("Défini la manière dont sont suivis les patients : </br>
                            - UptoEnd : depuis leur inclusion jusqu'à la fin de l'étude
                            - Fixed : chaque patient est suivi la même durée peu importe la date d'inclusion")
              ),
              
              tags$tr(
                tags$th("Type de test"),
                tags$td("Permet de spécifier le sens du test :
                            - 2-sided pour bilatéral 
                            - 1-sided pour unilatéral")
              ),
              
              tags$tr(
                tags$th("Variance de l'effet du traitement"),
                tags$td("Variance de la pente aléatoire (effet aléatoire associé à l’effet du traitement entre les groupes). La valeur par défaut est 0,1.")
              ),
              
              tags$tr(
                tags$th("Variance du risque de base"),
                tags$td("Variance de l’intercept aléatoire (effet aléatoire associé à la fonction du risque de base). La valeur par défaut est 0,1.")
              )
            )
          )
        )
      ),
                         
                         
### Calcul du NSN============================================================================================
                         
      tabItem(
        tabName = "calc_NSN",
          
        tags$h2("Données Groupées", id = "titre_page" ),
          
        tabsetPanel(
          tabPanel(
            "Paramétrage",
              
            h3("Paramètres du calcul du NSN", id = "sous_titre"),
              
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
                       selectInput("DG_NSN_repartition_par_groupe", "Répartition par groupe",
                                   c("Fixed",  "Unif"))),
                
                column(width = 4,
                       conditionalPanel(
                         condition = "input.DG_NSN_repartition_par_groupe == 'Fixed'",
                          numericInput("DG_NSN_nbr_sujet_par_grp", "Nombre de sujet par groupe", 15)),
                         
                        conditionalPanel(
                          condition = "input.DG_NSN_repartition_par_groupe == 'Unif'",
                          numericInput("DG_NSN_unif_a", "Nombre de sujet par groupe", 1),
                          numericInput("DG_NSN_unif_b", "Nombre de sujet par groupe", 2))
                ),
                  
                column(width = 4, numericInput("DG_NSN_ratio", "Ratio (n_e/n_c)", 1))
              )
            ),
              
            tags$br(),
            tags$br(),
              
            fluidRow(
              column(
                width = 6, 
                id = "DG_NSN_info_test_simu_FR",
                  
                h4("Test statistique", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_NSN_info_test",
                    
                  numericInput("DG_NSN_puissance", "Puissance", 0.8),
                    
                  selectInput("DG_NSN_type_test", "Type de test",
                                c("2-sided",  "1-sided")),
                    
                  numericInput("DG_NSN_alpha", "Erreur de type I", 0.05, min=0, max=0.2),
                    
                  selectInput("DG_NSN_stat_test", "Statistique de test",
                                c("Wald")),
                    
                  numericInput("DG_NSN_nbr_echantillon_MC", "Nombre de simulmation de Monte Carlo", 10000)
                ),
                  
                tags$br(),
                
                h4("Simulation", id = "sous_titre_sous_partie"),
                    
                div(
                  id="DG_NSN_simulation",
                    
                  checkboxInput(inputId = "DG_NSN_bootstrap", label = "Bootstrap", value = FALSE),
                      
                  numericInput("DG_NSN_nboot", "Nboot", 1000)
                )
              ),
                
              column(
                width = 6,
                id="DG_NSN_data_essai_col",
                  
                h4("Info à propos de l'essai", id = "sous_titre_sous_partie"),
                  
                div(
                  id="DG_NSN_data_essai",
                    
                  selectInput("DG_NSN_type_suivi", "Type de suivi",
                                c("UptoEnd",  "Fixed")),
                  tags$br(),
                    
                  p("Si on définit les périodes en mois alors respecter cette unité pour toutes les périodes entrées !"),
                  p("Les valeurs par défaut sont en mois."),
                    
                  numericInput("DG_NSN_periode_inclusion", "Période d'inclusion", 24),
                    
                  numericInput("DG_NSN_periode_suivi", "Période de suivi", 30),
                    
                  numericInput("DG_NSN_median_survie_h0", "Médiane de survie sous H0", 12),
                    
                  tags$br(),
                  tags$br(),
                    
                  numericInput("DG_NSN_HR", "Hazard Ratio", value= 0.75, min=0 , max=1),
                    
                  numericInput("DG_NSN_param_weibull", "Paramètre de Weibull", 1),
                    
                  numericInput("DG_NSN_variance_0", "Variance du risque de base intergroupe", 0.1),
                    
                  numericInput("DG_NSN_variance_1", "Variance d'effet du traitement intergroupe", 0.1),
                    
                  numericInput("DG_NSN_correlation_effet", "Corrélation entre les effets aléatoires", 0.5, min=-1, max=1)
                )
              )
            ),
              
            tags$br(),
              
            div(
              id = "DG_lance_NSN",
                
              actionButton(inputId="DG_lance_NSN", label="Calculer", class="btn btn-primary btn-lg", style="color: white;")
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
            "Aide",
              
            h3("Aide", id = "sous_titre"),
              
            tags$br(),
              
            tags$table(
                
              tags$tr(
                tags$th("Hazard Ratio (HR)"),
                tags$td("Calculer comme le rapport des risques instantanés dans le groupetraité divisé par le risque dans le groupe contrÃ´le")
              ),
                
              tags$tr(
                tags$th("Médiane attendue sous H0"),
                tags$td("Indique le délai attendu dans lequel la moitié des individus d'unéchantillon sont décédés, l'autre moitié étant encore vivante sousl'hypothèse H0")
              ),
                
              tags$tr(
                tags$th("Paramètre de Weibull"),
                tags$td("A définir")
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
        tags$h2("Données Récurrentes", id = "titre_page")
        
          # tabsetPanel(
          #   tabPanel(
          #     
          #   )
          # )
        
      ) #end tabItem de données récurrentes
    ) #end de tabItems
  ) #end de dashboardBody
) #end dashboardPage
