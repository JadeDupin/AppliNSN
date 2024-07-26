##working directory
setwd("P:/Appli NSN")

##source
source("Y:/Jade/Programmation/3 - Biomarker strategy design/Rcode_BSD_PCFM.R")


##calcul de puissance
calc_puiss <- PowerPCFM(NbGroupsExp=10,
                        ni=15,
                        ni_type="fixed", 
                        median_H0=12,
                        Acc_Dur=24, 
                        FUP=30, 
                        FUP_type="UptoEnd", 
                        beta0=log(1),
                        betaA=log(0.75), 
                        shape_W=1,    
                        theta=0.05, 
                        ratio=1, 
                        prop_neg=0.2,
                        Y_samples=100000,  
                        gamma0=log(1),
                        gammaA=log(0.5), 
                        method="joint",
                        statistic='Wald', 
                        typeIerror=0.05, 
                        test_type="2-sided", 
                        print.cens=FALSE, 
                        seed=105795)


calc_puiss




##calcul NSN
calc_nsn <- NsnPCFM(power=0.8,
                    ni=10,
                    ni_type="fixed", 
                    median_H0=12,
                    Acc_Dur=24, 
                    FUP=30, 
                    FUP_type="UptoEnd", 
                    beta0=log(1),
                    betaA=log(0.75), 
                    shape_W=1,
                    theta=0.05, 
                    ratio=1, 
                    prop_neg=0.1,
                    Y_samples=100000, 
                    gamma0=log(1), 
                    gammaA=log(0.5), 
                    method="joint",
                    statistic='Wald', 
                    typeIerror=0.05, 
                    test_type="2-sided", 
                    print.cens=FALSE,
                    seed=105795)


calc_nsn





























