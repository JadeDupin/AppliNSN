##working directory
setwd("P:/Appli NSN")

##Doc source des fonctions
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_SFM.R")

##Calcul de puissance
calc_puiss <- PowerSharedFM(
                    Groups=400,
                    ni=5,
                    ni_type="fixed", 
                    median_H0=1,
                    Acc_Dur=12, 
                    FUP=30, 
                    FUP_type="fixed", 
                    beta0=0,
                    betaA=log(0.75), 
                    shape_W=1,
                    theta=0.25, 
                    ratio=1, 
                    Y_samples=1000, 
                    death_par=12, 
                    death_type="expo",
                    statistic='Wald', 
                    typeIerror=0.05, 
                    test_type="2-sided", 
                    print.cens=FALSE, 
                    timescale='gap',
                    data_type="rec_event", 
                    seed=98968)

#affichage
calc_puiss

#récupération des résultats
puiss <- calc_puiss$power
puiss

calc_puiss$events
calc_puiss$censoring


##Calcul NSN
calc_NSN <- NsnSharedFM(
                    power=0.8, 
                    ni=5,
                    ni_type="fixed", 
                    median_H0=1,
                    Acc_Dur=12, 
                    FUP=30, 
                    FUP_type="UptoEnd", 
                    beta0=0,
                    betaA=log(0.75), 
                    shape_W=1,
                    theta=0.25, 
                    ratio=1, 
                    Y_samples=10000, 
                    death_par=c(1,9), 
                    death_type="Unif",
                    statistic='Wald', 
                    typeIerror=0.05, 
                    test_type="2-sided", 
                    print.cens=FALSE, 
                    timescale='gap',
                    seed=1546871, 
                    data_type="grouped")

calc_NSN
calc_NSN$Npts
calc_NSN$ni
calc_NSN$ni_type
calc_NSN$true_power
calc_NSN$alpha
calc_NSN$events
calc_NSN$censoring














































