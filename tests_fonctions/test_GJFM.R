##working directory
setwd("P:/Appli NSN")

##Doc source des fonctions
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_GJFM.R")



##Calcul de puissance
calc_puiss <- PowerGJFM(N_Pts=700,
                        ni=8,
                        ni_type="max", 
                        medianR_H0=3, 
                        medianD_H0=10,
                        Acc_Dur=1, 
                        FUP=12, 
                        FUP_type="fixed", 
                        method="joint",
                        betaR_0=0,
                        betaR_A=log(0.75), 
                        betaD_0=0,
                        betaD_A=log(0.85), 
                        shapeR_W=1, 
                        shapeD_W=1, 
                        theta=0.5, 
                        eta=0.1,
                        ratio=1, 
                        Y_samples=1000, 
                        timescale='gap', 
                        statistic='Wald', 
                        typeIerror=0.05, 
                        test_type="2-sided",
                        print.cens=FALSE,  
                        seed=774968)

calc_puiss


##Calcul de NSN
calc_NSN <- NsnGJFM(power=0.8,
                    ni=8,
                    ni_type="max", 
                    medianR_H0=3, 
                    medianD_H0=10,
                    Acc_Dur=1, 
                    FUP=12, 
                    FUP_type="fixed", 
                    method="joint",
                    betaR_0=0,
                    betaR_A=log(0.75), 
                    betaD_0=0,
                    betaD_A=log(0.85), 
                    shapeR_W=1, 
                    shapeD_W=1, 
                    theta=0.5, 
                    eta=0.1,
                    ratio=1, 
                    Y_samples=10000, 
                    timescale='gap', 
                    statistic='Wald', 
                    typeIerror=0.05, 
                    test_type="2-sided",
                    print.cens=FALSE,  
                    seed=1222)

calc_NSN










