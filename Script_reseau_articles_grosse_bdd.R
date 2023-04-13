#Constitution d'un réseau de so-citation d'articles scientifiques :

#
#
#

library(visNetwork) #package de visualisation de structure en réseau
library(igraph) #package de constitution et affichage de structure en réseau
library(tidyr) #package de traitement de bases de données, utilisé pour ranger les articles par degré décroissants
library(stringr) #package pour traiter les chaînes de caractères, utilisé pour sélectionner les DOI dans les Cited References
library(devtools)#package pour réaliser des fonctions simples sur R

# Importation de la base de données depuis Wos,
#exporter en format "Excel" en choisissant d'exporter les DOI des articles et les "Cited References"
#puis enregistrer les bases de données excel en format .csv en cochant "cellules délimitées par des " '

#Importation de la bases de données contenant les informations sur les articles 
bdd_brut1 <- read.table('savedrecs (2)_.csv', sep = ";", header = TRUE)
bdd_brut2 <- read.table('savedrecs (3).csv', sep = ";", header = TRUE)
bdd_brut3 <- read.table('savedrecs (4).csv', sep = ";", header = TRUE)

#fusion des documents .csv obtenus par extraction des articles sur WoS
bdd_brut <- rbind.data.frame(bdd_brut1, bdd_brut2, bdd_brut3)


#Récupérer unniquement les 2 colonnes qui nous intéressent dans la base de données importée depuis WoS
bdd <- data.frame(bdd_brut$Cited.References, bdd_brut$DOI)

# trier pour retirer de la bdd les articles sans auteurs 

bdd<- drop_na(bdd)


#constitution d'une edge list avec une ligne = 1 article citant et 1 article cité dans les sources du citant
nombre_articles_citants <- nrow(bdd)

for (i in 1:nombre_articles_citants){
  
  cites <- str_split(bdd$bdd_brut.Cited.References[i], "; ")
  citant_cite = rbind(citant_cite, data.frame(cites = cites[[1]] , citant = bdd$bdd_brut.DOI[i]))
  
}

View(cites)

View(citant_cite)

# création d'un objet edge_list avec en première colonne les DOI des articles cites 
#et en deuxième colonne les DOI des citants :

nombre_articles2 = nrow(citant_cite)

#test d'extraction de texte 
s="Zoupa M, 2017, INT J MOL SCI, V18, DOI 10.3390/ijms18040817"
str_extract(s, pattern = "DOI (\\d+)\\.(\\d+)/(\\X+)")


for (i in 1:nombre_articles2){
  citant_cite$cites[i]<- str_extract(citant_cite$cites[i], pattern = "DOI (\\d+)\\.(\\d+)/(\\X+)")
}

citant_cite<- drop_na(citant_cite)
View(citant_cite)

#Enlever les trois lettres "DOI" dans la colonne des articles cités :

nombre_lignes_3 <- nrow(citant_cite)

for (i in 1:nombre_articles2){
  citant_cite$cites[i]<- str_extract(citant_cite$cites[i], pattern = "(\\d+)\\.(\\d+)/(\\X+)")
}
View(citant_cite)

#création d'un nouvel objet en enlevant les articles qui ne sont pas cités :

nrow(citant_cite)
citant_cite_final <- citant_cite[citant_cite[,2] %in% unique(citant_cite[,1]),]
nrow(citant_cite_final)


#création du réseau 1 :
g <- graph_from_data_frame(citant_cite_final, directed = FALSE)

#test d'affiches de réseaux non aboutis : 

#nodes <- data.frame(citant_cite_final$cites)
#edges <- data.frame(from = citant_cite_final$citant, to = citant_cite_final$cites)

#View(nodes)
#View(edges)

#g<-as.matrix(citant_cite_final)
#g<-graph.edgelist(g, directed=TRUE)


#g <- graph_from_data_frame(d = edges, vertices = NULL, directed = FALSE)

# réseau en cercle : illisible
#plot(g, vertex.label = NA, layout=layout.circle(g)) 

#taille des noeuds en fonction du degreee : peu lisible

#deg <- degree(g, mode="all")
#V(g)$size <- deg*2


#Affichage du réseau : 
plot(g,
     vertex.color="#0000FF25", vertex.label=NA , vertex.size=4,
     edge.color="red",edge.width=0,1, edge.arrow.size = 0.01, margin = 0, layout = layout_nicely(g))


# calcul des degrés de chaque noeuds (=article) :


degres_reseau<- degree(
  g,
  v = V(g),
  mode = c("all", "out", "in", "total"),
  loops = TRUE,
  normalized = FALSE
)


print(degres_reseau)
degres_reseau[1]
max(degres_reseau)

#Classement des articles par ordre de degré décroissant
degres_reseau_trie <- sort(degres_reseau, decreasing = TRUE)
View(degres_reseau_trie)

# Enlever du réseau les noeuds ayant un degrés "trop faible" 
degres_reseau_list <- as.list(degres_reseau)
print(degres_reseau_list)
ID_noeuds_enleves = list()
length(degres_reseau_list)


for(i in 1:length(degres_reseau_list)){if (degres_reseau_list[i]<100){ID_noeuds_enleves <- c(ID_noeuds_enleves, names(degres_reseau_list)[i])}}

citant_cite_final2 <- citant_cite_final[!(citant_cite_final$cites %in% ID_noeuds_enleves),]


g <- graph_from_data_frame(citant_cite_final2, directed = FALSE)




#Affichage du réseau "allégé" :
plot(g,
     vertex.color="#0000FF25", vertex.label= NA , vertex.size=3,
     edge.color="red", edge.arrow.size = 0.01, margin = 0,1, layout = layout_nicely(g))


#visualisation avec VisNetwork 

visIgraph(g)
