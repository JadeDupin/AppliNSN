##working directory
setwd("P:/Appli NSN")

##Doc source des fonctions
source("Y:/Jade/Programmation/2 - Recurrent data/Rcode_NFM.R")

##Calcul de puissance
calc_puiss <- PowerNestedFM(Groups=40,
                            ni=10,
                            ni_type="fixed",
                            kij=15,
                            kij_type="fixed", 
                            median_H0=1,
                            Acc_Dur=0, 
                            FUP=30, 
                            FUP_type="UptoEnd", 
                            beta0=0,
                            betaA=log(0.75), 
                            shape_W=1, 
                            theta=.25,
                            eta=.5,
                            ratio=1, 
                            Y_samples=1000,  
                            death_par=c(5),
                            death_type="expo", 
                            data_type="rec_event2", 
                            timescale='gap', 
                            statistic='Wald', 
                            typeIerror=0.05, 
                            test_type="2-sided",
                            print.cens=FALSE, 
                            seed=1546871)

calc_puiss
calc_puiss$power
calc_puiss$events
calc_puiss$censoring



##Calcul NSN
calc_NSN <- NsnNestedFM(power=0.8,
                        ni=10,
                        ni_type="fixed",
                        kij=15,
                        kij_type="fixed", 
                        median_H0=1, 
                        Acc_Dur=0, 
                        FUP=30, 
                        FUP_type="UptoEnd", 
                        beta0=0,
                        betaA=log(0.75),
                        shape_W=1, 
                        theta=0.25, 
                        eta=.5, 
                        ratio=1, 
                        Y_samples=10000, 
                        death_par=5, 
                        death_type="expo",          
                        statistic='Wald', 
                        typeIerror=0.05, 
                        test_type="2-sided", 
                        print.cens=TRUE,
                        data_type="rec_event2", 
                        timescale='gap',        
                        seed=122 )


calc_NSN
calc_NSN$Groups
calc_NSN$ni
calc_NSN$ni_type
calc_NSN$kij
calc_NSN$kij_type
calc_NSN$true_power
calc_NSN$alpha
calc_NSN$events
calc_NSN$censoring











