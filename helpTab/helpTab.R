#---------------------------------------------------------------------------------------------------#
# Librairies-----------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------#
library(shiny)
library(DT)



# Choix de table-------------------------------------------------------------------------------------
### DG puissance :  DG_puiss_help
### DG NSN :        DG_NSN_help
### DR tous les modèles pr puissance et NSN : DR_puiss_NSN_help
### BSD :



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
            <br>      - Fixed: fixed number of subjects for each group
            <br>      - Unif: distribution of subjects according to a uniform distribution of parameters a and b",
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
           1, 
           1, 
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
           0, 
           0, 
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
             <br>     - UptoEnd: from inclusion to end of study 
             <br>     - Fixed: each patient is followed for the same length of time, regardless of inclusion date",
            1, 
            1, 
            1, 
            1, 
            1,
            0)

lign18 <- c("Type of test",
            "Allows to specify the direction of the test: 
             <br>     - 2-sided for two-sided   
             <br>     - 1-sided for unilateral",
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

lign22 <- c("Data type",
            "Type of data considered; can be either 'rec_event1', 'rec_event2' or 'grouped':
            <br>          - rec_event: corresponds to a patient experiencing recurrent events
            <br>          - grouped: corresponds to patients  included in a cluster",
            0,
            1,
            1,
            0,
            0,
            0)

lign23 <- c("Distribution of events",
            "Distribution of the number of expected event, can be either : 
            <br>      - Fixed/Maximum: fixed number of subjects for each group
            <br>      - Uniform: distribution of subjects according to a uniform distribution of parameters a and b
            <br>      - Poisson: distrubution according to the average of realisations",
            0,
            1,
            1,
            1,
            1,
            0)

lign24 <- c("Number of expected events",
            "Number of expected events per subgroup or per patient. 
            <br>      - Fixed/Maximum: correspond to a scalar
            <br>      - Uniform: 2 numbers to enter
            <br>      - Poisson: correspond to a scalar",
            0,
            1,
            1,
            1,
            1,
            0)

lign25 <- c("Distribution of subgroups",
            "Distribution of subgroups considered for:
            <br>      - Fixed: fixed number of subjects for each group
            <br>      - Uniform: distribution of subjects according to a uniform distribution of parameters a and b
            <br>      - Poisson: distrubution according to the average of realisations",
            0,
            0,
            1,
            0,
            0,
            0)

lign26 <- c("Timescale",
            "Only gap time is implemented",
            0,
            1,
            1,
            1,
            1,
            0)

lign27 <- c("Median time of recurrente event under H0", 
           "Expected median survival time of recurrent events under H0",
           0, 
           0, 
           0, 
           1, 
           1,
           0)

lign28 <- c("Median time of terminal event under H0", 
            "Expected median survival time of terminal events under H0",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign29 <- c("Shape parameter of Weibull for recurrent events",
            "Shape parameter of baseline risks of the Weibull distribution for recurrent events. Defaults to 1, assuming exponentially distributed survival times.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign30 <- c("Shape parameter of Weibull for terminal events",
            "Shape parameter of baseline risks of the Weibull distribution for terminal events. Defaults to 1, assuming exponentially distributed survival times.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign31 <- c("Variability of the baseline risk at the individual level",
            "Variability of the baseline risk at the individual level",
            0, 
            1, 
            0, 
            1, 
            1,
            0)

lign32 <- c("Variability of the baseline risk at the cluster level",
            "Variability of the baseline risk at the cluster level",
            0, 
            0, 
            1, 
            0, 
            0,
            0)

lign33 <- c("Variability of the baseline risk at the subcluster level",
            "Variability of the baseline risk at the subcluster level",
            0, 
            0, 
            1, 
            0, 
            0,
            0)

lign34 <- c("Variance of inter-recurrence",
            "Within-subject dependence between recurrent times",
            0, 
            0, 
            0, 
            0, 
            1,
            0)

lign35 <- c("Association between recurrent and terminal events",
            "Association parameter between recurrent and terminal events",
            0, 
            0, 
            0, 
            1, 
            0,
            0)

lign36 <- c("Number of patients", 
           "Number of patients to calculate test power. Performs power estimation, when specified.",
           0, 
           1, 
           1, 
           0, 
           0,
           0)

lign37 <- c("Distribution of death", 
            "Distribution of death times, can be either:
            <br>      - Uniform: distribution of subjects according to a uniform distribution of parameters a and b
            <br>      - Exponential: distribution of subject according to a exponential distribution of parameter lambda",
            0, 
            1, 
            1, 
            0, 
            0,
            0)

lign38 <- c("Censor time for death", 
            "Adding a censor time for death. Parameter required for death_type.",
            0, 
            1, 
            1, 
            0, 
            0,
            0)

lign39 <- c("Method", 
            "Can be either 'joint', 'betaRtest', or 'betaDtest' to estimate power when testing.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign40 <- c("Beta values for recurrent events under H0 (logarithm of)", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for recurrent events under H0.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign41 <- c("Beta values for recurrent events under HA (logarithm of)", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for recurrent events under HA.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign42 <- c("Beta values for terminal events under H0 (logarithm of)", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for terminal events under H0.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign43 <- c("Beta values for terminal events under HA (logarithm of)", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for terminal events under HA.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign44 <- c("Dependence between recurrent and terminal events", 
            "Dependence parameter between recurrent and terminal events",
            0, 
            0, 
            0, 
            1, 
            0,
            0)





#Création de la table 
tabDef <- data.frame(do.call("rbind", list(lign1, lign2, lign3, lign4, lign5, lign6, lign7, lign8, lign9, lign10, 
                                lign11, lign12, lign13, lign14, lign15, lign16, lign17, lign18, lign19, lign20,
                                lign21, lign22, lign23, lign24, lign25, lign26, lign27, lign28, lign29, lign30, 
                                lign31, lign32, lign33, lign34, lign35, lign36, lign37, lign38, lign39, lign40, 
                                lign41, lign42, lign43, lign44)))

colnames(tabDef) <- c("Nom",
                      "Definition", 
                      "DG", 
                      "DR_SFM", 
                      "DR_NFM", 
                      "DR_JFM", 
                      "DR_GJFM", 
                      "BSD")

tabDefOrder <- tabDef[order(tabDef$Nom),]


# Fonction---------------------------------------------------------------------------------------------------

choixTabHelp <- function(choix){
  
  
  # Filtrer les données en fonction du choix
  filtered_data <- switch(choix,
                    "DG_help" = tabDefOrder[tabDefOrder$DG == 1, ],
                    "DR_help" = tabDefOrder[tabDefOrder$DR_SFM == 1 | tabDefOrder$DR_NFM == 1 | tabDefOrder$DR_JFM == 1 | tabDefOrder$DR_GJFM == 1, ],
                    "BSD_help" = tabDefOrder[tabDefOrder$BSD == 1, ],
                    data.frame()
  )
  
  
  # Replace <br> tags with HTML line breaks
  filtered_data$Definition <- gsub("<br>", "<br/>", filtered_data$Definition)
  
  #Tableau interactif
  datatable(filtered_data,
            escape = FALSE, # Prevent escaping HTML
            options = list(lengthChange = FALSE, # Disable entries option
                           searching = FALSE, # Disable search
                           pageLength = dim(filtered_data)[1],
                           #scrollX = TRUE,
                           #scrollY = TRUE,
                           autoWidth = TRUE,
                           server = FALSE,
                           dom = 'ftp',
                           columnDefs = list(list(targets = '_all', className = 'dt-center'),
                                             list(targets = c(2:7), visible = FALSE)) # hide column 3 to 8
            ),
            selection = 'single',
            filter = 'top',
            rownames = FALSE
  )  %>% formatStyle(
    columns = "Nom",
    className = "bold-text" # Apply CSS class to column
  )
  
  
} # fin choixTabHelp






















