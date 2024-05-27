##working directory
setwd("P:/Appli NSN")

##Doc source des fonctions
source("Y:/Jade/Programmation/AddFM - Moi.R")

##valeurs au hasard pour le moment
data <- Data_generation(G=4,ni=5,ni_type='fixed',beta=log(0.75),P_E=0.5,mu=,sigma=matrix(),Inc=,adm_cens=,weib_p=)

##calcul de puissance
calc_puiss <- PowerAddFM(Nb_groups=10,
           ni=c(1,20), ni_type="unif", 
           median_H0=12,
           Acc_Dur=24, FUP=30, FUP_type="UptoEnd", 
           HR=0.75, 
           shape_W=1,
           sigma0_2=0.1, sigma1_2=0.05, 
           rho=0, 
           ratio=1,
           Y_samples=100,
           statistic='Wald', 
           typeIerror=0.05, test_type="2-sided", 
           print.cens=FALSE, 
           Bootstrap=FALSE, Nboot=1000, 
           seed=105795)

puissance <- calc_puiss$power
str(puissance)

#rÈcupÈration de la puissance calculÈe
calc_puiss$power

##calcul NSN ==> donne le nombre de groupe n√©cessaire pour ni(=15 par groupe ici) pour atteindre une telle puissance avec ces param√®tres
calc_NSN <- NSNaddFM(power=0.8, 
         ni=c(1,2) ,ni_type="unif", 
         median_H0=12 ,
         Acc_Dur=24, FUP=30, FUP_type="UptoEnd", 
         Y_samples=10000,
         HR=0.75, 
         shape_W=1, 
         ratio=1, 
         sigma0_2=0.1, sigma1_2=0.05, 
         rho=0, 
         seed=105795, 
         print.cens=FALSE,
         statistic='Wald', 
         typeIerror=0.05, test_type="2-sided", 
         Bootstrap=FALSE, Nboot=1000)




























