1- Installer R & Rstudio 
2- Lancer Rstudio et depuis Tools\Download Package, installer le package "Shiny"
3- Dans Rstudio copier coller la ligne suivante
install.packages(c("ggplot2","stringr","dplyr","plyr"), dependencies = T)
Et cliquer Entrer pour charger d'autres packages
4- Si il y a eu des erreurs lors de l'install, alors faites un chargeemnt des packages (notamment plyr et dplyr ) direct depuis le menu Tools/Install Packages
5- Recommencer plusieurs fois le 4 si vous ne voyer pas les fenetres de Download apparaitre
6- T�l�charger depuis le GitHub LIttoSIM l'appli d�velopp� pour LittoSIM appel� Shiny-app
7- Dans RStudio faite un OpenFile de cette appli
8- Puis cliquer sur Run APP
