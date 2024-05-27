##working directory
setwd("P:/Appli NSN")

##Doc source des fonctions
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_JFM.R")



##Calcul de puissance

# Example 1: Test only on recurrent events - method="betaRtest"
calc_puiss1 <- PowerJFM(N_Pts=400,
                        ni=8,
                        ni_type="max",
                        medianR_H0=3, 
                        medianD_H0=10,
                        Acc_Dur=0, 
                        FUP=20, 
                        FUP_type="UptoEnd",
                        method="betaRtest", 
                        betaR_0=0,
                        betaR_A=log(.75), 
                        betaD_0=0,
                        betaD_A=log(.85), 
                        shapeR_W=1, 
                        shapeD_W=1,
                        theta=.5, 
                        alpha=0, 
                        ratio=1, 
                        Y_samples=10000,
                        timescale='gap', 
                        statistic='Wald', 
                        typeIerror=0.05, 
                        test_type="2-sided",
                        print.cens=TRUE,
                        seed=77)
  
calc_puiss1
calc_puiss1$power
calc_puiss1$events_rec
calc_puiss1$events_D
calc_puiss1$censoring_rec
calc_puiss1$censoring_D


# Example 2: Test  on recurrent and death events - method="joint"
calc_puiss2 <- PowerJFM(N_Pts=400,
                        ni=8,
                        ni_type="max", 
                        medianR_H0=3, 
                        medianD_H0=10,
                        Acc_Dur=0, 
                        FUP=20, 
                        FUP_type="UptoEnd",
                        method="joint", 
                        betaR_0=0,
                        betaR_A=log(.75), 
                        betaD_0=0,
                        betaD_A=log(.85), 
                        shapeR_W=1, 
                        shapeD_W=1,
                        theta=.5, 
                        alpha=0, 
                        ratio=1, 
                        Y_samples=10000,
                        timescale='gap', 
                        statistic='Wald',
                        typeIerror=0.05, 
                        test_type="2-sided", 
                        print.cens=TRUE,
                        seed=77)
  
  
  
  
##Calcul de puissance
calc_NSN <- NsnJFM(power=0.8,
                   ni=8,
                   ni_type="max", 
                   medianR_H0=3, 
                   medianD_H0=10,
                   Acc_Dur=0, 
                   FUP=20, 
                   FUP_type="UptoEnd",
                   method="joint", 
                   betaR_0=0,
                   betaR_A=log(.75), 
                   betaD_0=0,
                   betaD_A=log(.85), 
                   shapeR_W=1, 
                   shapeD_W=1,
                   theta=.5, 
                   alpha=0, 
                   ratio=1, 
                   Y_samples=10000,
                   timescale='gap', 
                   statistic='Wald',
                   typeIerror=0.05, 
                   test_type="2-sided", 
                   print.cens=TRUE,
                   seed=77)



calc_NSN

















