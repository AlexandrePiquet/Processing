# EVOLUTION PARTIES
v.1.3 du 26/10/2021

## Principe

Visualisation du nombre total de parties effectuées pour les N jeux les plus joués.
Enregistrement en vidéo.

## Entrée - sortie

+ Entrée

Fichier partie.csv : 
1ère ligne : Date;[jeu 1];[jeu 2];...;[jeu n]<br>
autres lignes : jj/mm/aa;[nombre cumulé de parties pour le jeu 1];[pour le jeu 2];...;[pour le jeu n]

Possiblement fichiers [nom du jeu].jpg

+ Sortie

Fichier test.mp4.

## Fonctionnement

1. Lancer Processing
2. Modifier les variables suivantes si nécessaire : 
  + cheminEntree
  + cheminSortie
  + NBR_JEUX
  + FRAMES_PER_DAY
  + largeur
  + hauteur
  + éventuellement commenter / décommenter les lignes correspondant à l'utilisation d'images
3. Exécuter le script
4. Récupérer le fichier mp4

