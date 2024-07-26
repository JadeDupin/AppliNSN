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

lign1 <- c("<div class='bold-text'>Bootstrap</div>",  
           "Logical parameter for running a Bootstrap method to calculate the confidence interval for power estimates. <br>Default value is FALSE (box unchecked).",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign2 <- c("<div class='bold-text'>Correlation between both random effects</div>", 
           "Correlation coefficient between the two fragilities. <br>Default value is 0.5.",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign3 <- c("<div class='bold-text'>Distribution of patient by groupe</div>", 
           "Distribution of subjects within groups :
            <br>      - Fixed: fixed number of subjects for each group
            <br>      - Unif: distribution of subjects according to a uniform distribution of parameters a and b",
           1, 
           0, 
           0, 
           0, 
           0,
           1)

lign4 <- c("<div class='bold-text'>Follow-up period</div>",
           "Duration of follow-up (same unit as the median)",
           1, 
           1, 
           1, 
           1, 
           1,
           1)

lign5 <- c("<div class='bold-text'>Hazard Ratio (HR)</div>", 
           "Hazard ratio or ratio of median survival times",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign6 <- c("<div class='bold-text'>Inclusion period</div>", 
           "Period allocated to patient inclusion (same unit as the median)",
           1, 
           1, 
           1, 
           1, 
           1,
           1)

lign7 <- c("<div class='bold-text'>Median survival time under H0</div>", 
           "The survival median under null hypothesis",
           1, 
           1, 
           1, 
           0, 
           0,
           1)

lign8 <- c("<div class='bold-text'>Number of bootstrap resamples</div>", 
           "Default 1000",
           1, 
           0, 
           0, 
           0, 
           0,
           0)

lign9 <- c("<div class='bold-text'>Number of groups</div>", 
           "Number of groups to calculate test power. <br>Performs power estimation, when specified.",
           1, 
           0, 
           0, 
           1, 
           1,
           1)

lign10 <- c("<div class='bold-text'>Number of Monte Carlo runs</div>",
            "Number of runs launched to approximate the Fisher matrix by simulations",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign11 <- c("<div class='bold-text'>Number of subjects per group</div>", 
            "Number of patients expected in each group",
            1, 
            0, 
            0, 
            0, 
            0,
            1)

lign12 <- c("<div class='bold-text'>Ratio</div>", 
            "Randomization ratio in favor of the experimental arm. <br>Default value is 1.",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign13 <- c("<div class='bold-text'>Seed</div>",
            "Seed for reproducing estimates",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign14 <- c("<div class='bold-text'>Shape parameter of Weibull</div>",
            "Shape parameter of the Weibull distribution. Defaults to 1, assuming exponentially distributed survival times.",
            1, 
            1, 
            1, 
            0, 
            0,
            1)

lign15 <- c("<div class='bold-text'>Statistic</div>",
            "The test used to evaluate whether there is a significant clinical effect between treatment arms",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign16 <- c("<div class='bold-text'>Type I error</div>",
            "Type I error rate or significance level. Default 0.05.",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign17 <- c("<div class='bold-text'>Type of follow-up</div>", 
            "Defines how patients are monitored: 
             <br>     - UptoEnd: from inclusion to end of study 
             <br>     - Fixed: each patient is followed for the same length of time, regardless of inclusion date",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign18 <- c("<div class='bold-text'>Type of test</div>",
            "Allows to specify the direction of the test: 
             <br>     - 2-sided for two-sided   
             <br>     - 1-sided for unilateral",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign19 <- c("<div class='bold-text'>Variance of treatment effect</div>",
            "Variance of random slope (random effect associated with treatment effect between groups). <br>Default value is 0.1.",
            1,
            0,
            0,
            0,
            0,
            0)

lign20 <- c("<div class='bold-text'>Variance of the baseline risk</div>",
            "Random intercept variance (random effect associated with the basis risk function). <br>Default value is 0.1.",
            1,
            0,
            0,
            0,
            0,
            0)

lign21 <- c("<div class='bold-text'>Power</div>",
            "The probability of detecting the predefined significant effect (HR) and is defined as 1-type II error.",
            1, 
            1, 
            1, 
            1, 
            1,
            1)

lign22 <- c("<div class='bold-text'>Data type</div>",
            "Type of data considered; can be either 'rec_event1', 'rec_event2' or 'grouped':
            <br>          - rec_event: corresponds to a patient experiencing recurrent events
            <br>          - grouped: corresponds to patients  included in a cluster",
            0,
            1,
            1,
            0,
            0,
            0)

lign23 <- c("<div class='bold-text'>Distribution of events</div>",
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

lign24 <- c("<div class='bold-text'>Number of expected events</div>",
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

lign25 <- c("<div class='bold-text'>Distribution of subgroups</div>",
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

lign26 <- c("<div class='bold-text'>Timescale</div>",
            "Only gap time is implemented",
            0,
            1,
            1,
            1,
            1,
            0)

lign27 <- c("<div class='bold-text'>Median time of recurrente event under H0</div>", 
           "Expected median survival time of recurrent events under H0",
           0, 
           0, 
           0, 
           1, 
           1,
           0)

lign28 <- c("<div class='bold-text'>Median time of terminal event under H0</div>", 
            "Expected median survival time of terminal events under H0",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign29 <- c("<div class='bold-text'>Shape parameter of Weibull for recurrent events</div>",
            "Shape parameter of baseline risks of the Weibull distribution for recurrent events. <br>Defaults to 1, assuming exponentially distributed survival times.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign30 <- c("<div class='bold-text'>Shape parameter of Weibull for terminal events</div>",
            "Shape parameter of baseline risks of the Weibull distribution for terminal events. <br>Defaults to 1, assuming exponentially distributed survival times.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign31 <- c("<div class='bold-text'>Variability of the baseline risk at the individual level</div>",
            "Variability of the baseline risk at the individual level",
            0, 
            1, 
            0, 
            1, 
            1,
            1)

lign32 <- c("<div class='bold-text'>Variability of the baseline risk at the cluster level</div>",
            "Variability of the baseline risk at the cluster level",
            0, 
            0, 
            1, 
            0, 
            0,
            0)

lign33 <- c("<div class='bold-text'>Variability of the baseline risk at the subcluster level</div>",
            "Variability of the baseline risk at the subcluster level",
            0, 
            0, 
            1, 
            0, 
            0,
            0)

lign34 <- c("<div class='bold-text'>Variance of inter-recurrence</div>",
            "Within-subject dependence between recurrent times",
            0, 
            0, 
            0, 
            0, 
            1,
            0)

lign35 <- c("<div class='bold-text'>Association between recurrent and terminal events</div>",
            "Association parameter between recurrent and terminal events",
            0, 
            0, 
            0, 
            1, 
            0,
            0)

lign36 <- c("<div class='bold-text'>Number of patients</div>", 
           "Number of patients to calculate test power. Performs power estimation, when specified.",
           0, 
           1, 
           1, 
           0, 
           0,
           0)

lign37 <- c("<div class='bold-text'>Distribution of death</div>", 
            "Distribution of death times, can be either:
            <br>      - Uniform: distribution of subjects according to a uniform distribution of parameters a and b
            <br>      - Exponential: distribution of subject according to a exponential distribution of parameter lambda",
            0, 
            1, 
            1, 
            0, 
            0,
            0)

lign38 <- c("<div class='bold-text'>Censor time for death</div>", 
            "Adding a censor time for death. Parameter required for death_type.",
            0, 
            1, 
            1, 
            0, 
            0,
            0)

lign39 <- c("<div class='bold-text'>Method</div>", 
            "Can be either 'joint', 'betaRtest', or 'betaDtest' to estimate power when testing.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign40 <- c("<div class='bold-text'>Beta values for recurrent events under H0 (logarithm of HR)</div>", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for recurrent events under H0.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign41 <- c("<div class='bold-text'>Beta values for recurrent events under HA (logarithm of HR)</div>", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for recurrent events under HA.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign42 <- c("<div class='bold-text'>Beta values for terminal events under H0 (logarithm of HR)</div>", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for terminal events under H0.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign43 <- c("<div class='bold-text'>Beta values for terminal events under HA (logarithm of HR)</div>", 
            "Beta values corresponding to the logarithm of the Hazard Ratio for terminal events under HA.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign44 <- c("<div class='bold-text'>Dependence between recurrent and terminal events</div>", 
            "Dependence parameter between recurrent and terminal events",
            0, 
            0, 
            0, 
            1, 
            0,
            0)

lign45 <- c("<div class='bold-text'>Patient with the control in experimental arm</div>", 
            "Proportion of patient in the experimental arm that don't have identified molecular therapy. <br>Value between 0 and 1. ",
            0, 
            0, 
            0, 
            0, 
            0,
            1)

lign46 <- c("<div class='bold-text'>Method</div>", 
            "Can be either 'joint', 'betatest', or 'gammatest' to estimate power when testing.",
            0, 
            0, 
            0, 
            1, 
            1,
            0)

lign47 <- c("<div class='bold-text'>Beta values under H0 (logarithm of HR)</div>", 
            "Beta values corresponding to the logarithm of the Hazard Ratio under H0.",
            0, 
            0, 
            0, 
            0, 
            0,
            1)

lign48 <- c("<div class='bold-text'>Beta values under HA (logarithm of HR)</div>", 
            "Beta values corresponding to the logarithm of the Hazard Ratio under HA.",
            0, 
            0, 
            0, 
            0, 
            0,
            1)

lign49 <- c("<div class='bold-text'>Gamma values under H0 (logarithm of HR)</div>", 
            "Gamma values corresponding to the targeted treatment effect under H0.",
            0, 
            0, 
            0, 
            0, 
            0,
            1)

lign50 <- c("<div class='bold-text'>Gamma values under HA (logarithm of HR)</div>", 
            "Gamma values corresponding to the targeted treatment effect under HA.",
            0, 
            0, 
            0, 
            0, 
            0,
            1)




#Création de la table 
tabDef <- data.frame(do.call("rbind", list(lign1, lign2, lign3, lign4, lign5, lign6, lign7, lign8, lign9, lign10, 
                                lign11, lign12, lign13, lign14, lign15, lign16, lign17, lign18, lign19, lign20,
                                lign21, lign22, lign23, lign24, lign25, lign26, lign27, lign28, lign29, lign30, 
                                lign31, lign32, lign33, lign34, lign35, lign36, lign37, lign38, lign39, lign40, 
                                lign41, lign42, lign43, lign44, lign45, lign46, lign47, lign48, lign49, lign50)))

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
  #filtered_data$Definition <- gsub("<br>", "<br/>", filtered_data$Definition)
  
  # Apply bold-text class to Column1
  #filtered_data$Nom <- paste0('<span class="bold-text">', filtered_data$Nom, '</span>')
  
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
                           columnDefs = list(list(targets = '_all', className = 'dt-justify'),
                                             list(targets = c(2:7), visible = FALSE)) # hide column 3 to 8
            ),
            selection = 'single',
            filter = 'top',
            rownames = FALSE
  )
  
  
} # fin choixTabHelp






















