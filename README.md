# Projet-5-CNUM

## Création d'une structure en réseau de co-citation d'articles

### Résumé

Ce script traite des bases de données ".csv" extraites depuis **Web of Sciences** pour constituer un réseau de co-citation d'articles scientifiques. 
Les noeuds de ce réseau sont les DOI des articles de la base de données et les liens du réseau sont les citations entre les articles. 
La constitution du réseau permet de calculer les degrés de chaque articles, c'est-à-dire le nombre de citations par d'autres articles du réseau. 
Cela permet d'identifier les 5 articles les plus cités de la base de donnée étudiée, qui peuvent constituer les articles à consulter en premier dans la bibliographie du sujet.

### Détails techniques

* Le répertoire de travail contient les 3 bases de données (concaténées dans le script) utilisées pour le projet. 

* La branche "master" contient le script envoyé depuis git bash.

* Les fichiers R sont encodés en UTF8
