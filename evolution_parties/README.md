# EVOLUTION PARTIES
v.1.5 du 26/10/2021

## Principe

Visualisation du nombre total de parties effectuées pour les N jeux les plus joués.
Enregistrement en vidéo.

## Entrée - sortie

+ Entrée

Fichier partie.csv : 
1ère ligne : Date;[jeu 1];[jeu 2];...;[jeu n]<br>
autres lignes : jj/mm/aa;[nombre cumulé de parties pour le jeu 1];[pour le jeu 2];...;[pour le jeu n]

Possiblement fichiers [nom_du_jeu].jpg

+ Sortie

Fichier test.mp4.

## Fonctionnement

1. Lancer Processing
2. Modifier les variables suivantes si nécessaire : 
  + cheminEntree
  + cheminSortie
  + utilisationImage
  + tailleImage
  + NBR_JEUX
  + FRAMES_PER_DAY
  + largeur
  + hauteur
3. Exécuter le script
4. Récupérer le fichier mp4

## Notes

Prendre en compte la taille des images pour choisir la largeur, la hauteur et le nombre de jeux à afficher


