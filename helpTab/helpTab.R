#---------------------------------------------------------------------------------------------------#
# Librairies-----------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
library(shiny)



# Choix de table-------------------------------------------------------------------------------------
### DG puissance :  DG_puiss_help
### DG NSN :        DG_NSN_help
### DR tous les modèles pr puissance et NSN : DR_puiss_NSN_help
### BSD :




# # Fonction-------------------------------------------------------------------------------------------
# choixTabHelp0 <- function(choix){
#   
#   ## DG puissance====================================================================================
#   if(choix == "DG_puiss_help"){
#     tags$table(
#       
#       tags$tr(
#         tags$th("Bootstrap"),
#         tags$td("Logical parameter for running a Bootstrap method to calculate the confidence interval for power estimates. Default value is FALSE (box unchecked).")
#       ),
#       
#       tags$tr(
#         tags$th("Correlation between both random effects"),
#         tags$td("Correlation coefficient between the two fragilities. Default value is 0.5.")
#       ),
#       
#       tags$tr(
#         tags$th("Distribution of patient by groupe"),
#         tags$td("Distribution of subjects within groups :
#                             - Fixed: fixed number of subjects for each group
#                             - Unif: distribution of subjects according to a uniform distribution of parameters a and b")
#       ),
#       
#       tags$tr(
#         tags$th("Follow-up period"),
#         tags$td("Duration of follow-up (same unit as the median).")
#       ),
#       
#       tags$tr(
#         tags$th("Hazard Ratio (HR)"),
#         tags$td("the hazard ratio or ratio of median survival times.")
#       ),
#       
#       tags$tr(
#         tags$th("Inclusion period"),
#         tags$td("Period allocated to patient inclusion (same unit as the median).")
#       ),
#       
#       tags$tr(
#         tags$th("Median survival time under H0"),
#         tags$td("The survival median under null hypothesis.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of bootstrap resamples"),
#         tags$td("Default 1000.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of groups"),
#         tags$td("Number of groups to calculate test power. Performs power estimation, when specified.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of Monte Carlo runs"),
#         tags$td("Number of runs launched to approximate the Fisher matrix by simulations.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of subjects per group"),
#         tags$td("Number of patients expected in each group.")
#       ),
#       
#       tags$tr(
#         tags$th("Ratio"),
#         tags$td("Randomization ratio in favor of the experimental arm. Default value is 1.")
#       ),
#       
#       tags$tr(
#         tags$th("Seed"),
#         tags$td("Seed for reproducing estimates.")
#       ),
#       
#       tags$tr(
#         tags$th("Shape parameter of Weibull"),
#         tags$td("Shape parameter of the Weibull distribution. Defaults to 1, assuming exponentially distributed survival times.")
#       ),
#       
#       tags$tr(
#         tags$th("Statistic"),
#         tags$td("The test used to evaluate whether there is a significant clinical effect between treatment arms")
#       ),
#       
#       tags$tr(
#         tags$th("Type I error"),
#         tags$td("Type I error rate or significance level. Default 0.05.")
#       ),
#       
#       tags$tr(
#         tags$th("Type of follow-up"),
#         tags$td("Defines how patients are monitored:
#                             - UptoEnd: from inclusion to end of study
#                             - Fixed: each patient is followed for the same length of time, regardless of inclusion date")
#       ),
#       
#       tags$tr(
#         tags$th("Type of test"),
#         tags$td("Allows to specify the direction of the test:
#                             - 2-sided for two-sided 
#                             - 1-sided for unilateral")
#       ),
#       
#       tags$tr(
#         tags$th("Variance of treatment effect"),
#         tags$td("Variance of random slope (random effect associated with treatment effect between groups). Default value is 0.1.")
#       ),
#       
#       tags$tr(
#         tags$th("Variance of the baseline risk"),
#         tags$td("Random intercept variance (random effect associated with the basis risk function). Default value is 0.1.")
#       )
#     )
#   }
#   
#   ## DG NSN==========================================================================================
#   else if(choix == "DG_NSN_help"){
#     tags$table(
#       
#       tags$tr(
#         tags$th("Bootstrap"),
#         tags$td("Logical parameter for running a Bootstrap method to calculate the confidence interval for power estimates. Default value is FALSE (box unchecked).")
#       ),
#       
#       tags$tr(
#         tags$th("Correlation between both random effects"),
#         tags$td("Correlation coefficient between the two fragilities. Default value is 0.5.")
#       ),
#       
#       tags$tr(
#         tags$th("Distribution by groupe"),
#         tags$td("Distribution of subjects within groups :
#                             - Fixed: fixed number of subjects for each group
#                             - Unif: distribution of subjects according to a uniform distribution of parameters a and b")
#       ),
#       
#       tags$tr(
#         tags$th("Follow-up period"),
#         tags$td("Duration of follow-up (same unit as the median).")
#       ),
#       
#       tags$tr(
#         tags$th("Hazard Ratio (HR)"),
#         tags$td("the hazard ratio or ratio of median survival times.")
#       ),
#       
#       tags$tr(
#         tags$th("Inclusion period"),
#         tags$td("Period allocated to patient inclusion (same unit as the median).")
#       ),
#       
#       tags$tr(
#         tags$th("Median survival time under H0"),
#         tags$td("The survival median under null hypothesis.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of bootstrap resamples"),
#         tags$td("Default 1000.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of Monte Carlo runs"),
#         tags$td("Number of runs launched to approximate the Fisher matrix by simulations.")
#       ),
#       
#       tags$tr(
#         tags$th("Number of subjects per group"),
#         tags$td("Number of patients expected in each group.")
#       ),
#       
#       tags$tr(
#         tags$th("Power"),
#         tags$td("The probability of detecting the predefined significant effect (HR) and is defined as 1-type II error.")
#       ),
#       
#       tags$tr(
#         tags$th("Ratio"),
#         tags$td("andomization ratio in favor of the experimental arm. Default value is 1.")
#       ),
#       
#       tags$tr(
#         tags$th("Seed"),
#         tags$td("Seed for reproducing estimates.")
#       ),
#       
#       tags$tr(
#         tags$th("Shape parameter of Weibull"),
#         tags$td("Shape parameter of the Weibull distribution. Defaults to 1, assuming exponentially distributed survival times.")
#       ),
#       
#       tags$tr(
#         tags$th("Statistic"),
#         tags$td("The test used to evaluate whether there is a significant clinical effect between treatment arms")
#       ),
#       
#       tags$tr(
#         tags$th("Type I error"),
#         tags$td("Type I error rate or significance level. Default 0.05.")
#       ),
#       
#       tags$tr(
#         tags$th("Type of follow-up"),
#         tags$td("Defines how patients are monitored:
#                             - UptoEnd: from inclusion to end of study
#                             - Fixed: each patient is followed for the same length of time, regardless of inclusion date")
#       ),
#       
#       tags$tr(
#         tags$th("Type of test"),
#         tags$td("Allows to specify the direction of the test:
#                             - 2-sided for two-sided 
#                             - 1-sided for unilateral")
#       ),
#       
#       tags$tr(
#         tags$th("Variance of treatment effect"),
#         tags$td("Variance of random slope (random effect associated with treatment effect between groups). Default value is 0.1.")
#       ),
#       
#       tags$tr(
#         tags$th("Variance of the baseline risk"),
#         tags$td("Random intercept variance (random effect associated with the basis risk function). Default value is 0.1.")
#       )
#     )
#   }
#   
#   ## DR NSN==========================================================================================
#   else if(choix == "DR_puiss_NSN_help"){
#     tags$table(
#       
#       tags$tr(
#         tags$th("NAME"),
#         tags$td("DEF")
#       )
#     )
#   }
# }






# Dataset des définitions------------------------------------------------------------------------------------

# Ordre des variables :   "Nom", 
#                         "Def", 
#                         "DG      (oui = 1 / non = 2)", 
#                         "DR_SFM  (1/0)", 
#                         "DR_NFM  (1/0)", 
#                         "DR_JFM  (1/0)", 
#                         "DR_GJFM (1/0)", 
#                         "BSD     (1/0)"

lign1 <- c("Bootstrap",  
           "Logical parameter for running a Bootstrap method to calculate the confidence interval for power estimates. Default value is FALSE (box unchecked).",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign2 <- c("Correlation between both random effects", 
           "Correlation coefficient between the two fragilities. Default value is 0.5.",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign3 <- c("Distribution of patient by groupe", 
           "Distribution of subjects within groups :
            \n      - Fixed: fixed number of subjects for each group
            \n      - Unif: distribution of subjects according to a uniform distribution of parameters a and b",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign4 <- c("Follow-up period",
           "Duration of follow-up (same unit as the median)",
           1, 
           1, 
           1, 
           1, 
           1,
           0)

lign5 <- c("Hazard Ratio (HR)", 
           "Hazard ratio or ratio of median survival times",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign6 <- c("Inclusion period", 
           "Period allocated to patient inclusion (same unit as the median)",
           1, 
           1, 
           1, 
           1, 
           1,
           0)

lign7 <- c("Median survival time under H0", 
           "The survival median under null hypothesis",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign8 <- c("Number of bootstrap resamples", 
           "Default 1000",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign9 <- c("Number of groups", 
           "Number of groups to calculate test power. Performs power estimation, when specified.",
           1, 
           1, 
           1, 
           1, 
           1,
           0)

lign10 <- c("Number of Monte Carlo runs",
            "Number of runs launched to approximate the Fisher matrix by simulations",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign11 <- c("Number of subjects per group", 
            "Number of patients expected in each group",
            1, 
            0, 
            0, 
            0, 
            0,
            0)

lign12 <- c("Ratio", 
            "Randomization ratio in favor of the experimental arm. Default value is 1.",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign13 <- c("Seed",
            "Seed for reproducing estimates",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign14 <- c("Shape parameter of Weibull",
            "Shape parameter of the Weibull distribution. Defaults to 1, assuming exponentially distributed survival times.",
            1, 
            1, 
            1, 
            0, 
            0,
            0)

lign15 <- c("Statistic",
            "The test used to evaluate whether there is a significant clinical effect between treatment arms",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign16 <- c("Type I error",
            "Type I error rate or significance level. Default 0.05.",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign17 <- c("Type of follow-up", 
            "Defines how patients are monitored: 
             \n     - UptoEnd: from inclusion to end of study 
             \n     - Fixed: each patient is followed for the same length of time, regardless of inclusion date",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign18 <- c("Type of test",
            "Allows to specify the direction of the test: 
             \n     - 2-sided for two-sided   
             \n     - 1-sided for unilateral",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign19 <- c("Variance of treatment effect",
            "Variance of random slope (random effect associated with treatment effect between groups). Default value is 0.1.",
            1,
            0,
            0,
            0,
            0,
            0)

lign20 <- c("Variance of the baseline risk",
            "Random intercept variance (random effect associated with the basis risk function). Default value is 0.1.",
            1,
            0,
            0,
            0,
            0,
            0)

lign21 <- c("Power",
            "The probability of detecting the predefined significant effect (HR) and is defined as 1-type II error.",
            1, 
            1, 
            1, 
            1, 
            1,
            0)


#Création de la table 
tabDef <- data.frame(do.call("rbind", list(lign1, lign2, lign3, lign4, lign5, lign6, lign7, lign8, lign9, lign10, 
                                lign11, lign12, lign13, lign14, lign15, lign16, lign17, lign18, lign19, lign20,
                                lign21)))

colnames(tabDef) <- c("Nom",
                      "Def", 
                      "DG", 
                      "DR_SFM", 
                      "DR_NFM", 
                      "DR_JFM", 
                      "DR_GJFM", 
                      "BSD")

tabDefOrder <- tabDef[order(tabDef$Nom),]


# Fonction---------------------------------------------------------------------------------------------------

choixTabHelp <- function(choix){
  
  # Fonction pour générer les lignes de tableau
  generate_rows <- function(indices) {
    lapply(indices, function(i) {
      tags$tr(
        tags$th(tabDefOrder$Nom[i]),
        tags$td(tabDefOrder$Def[i])
      )
    })
  }
  
  # Sélection des indices en fonction du choix
  indices <- switch(choix,
                    "DG_help" = which(tabDefOrder$DG == 1),
                    "DR_help" = which(tabDefOrder$DR_SFM == 1 | tabDefOrder$DR_NFM == 1 | tabDefOrder$DR_JFM == 1 | tabDefOrder$DR_GJFM == 1),
                    "BSD_help" = which(tabDefOrder$BSD == 1),
                    integer(0) # valeur par défaut si le choix n'est pas valide
  )
  
  # Génération des lignes
  rows <- generate_rows(indices)
  
  # Création du tableau
  tags$table(
    do.call(tags$tbody, rows)
  ) 
  
  
} # fin choixTabHelp






















