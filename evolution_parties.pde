/*
Réalisé d'après la méthode de Cary H de la chaîne Abacaba
Tuto vidéo : https://www.youtube.com/watch?v=XCiKO-Qysqk&list=PLsRQr3mpFF3Khoca0cXA8-_tSloCwlZK8
code : https://github.com/carykh/AbacabaTutorialDrawer/blob/main/AbacabaTutorialDrawer.pde

Structure du fichier .csv nécessaire : 
- 1ère colonne pour les dates,
- puis une colonne par jeu,
- les cellules contiennent le nombre de parties CUMULEES.

Code écrit par Alexandre Piquet
v.1.3 du 29/10/2021
*/

import java.util.*;
import com.hamoid.*;

//Variables
int NOMBRE_JOURS;
int NOMBRE_JEUX;
//Fichier .csv contenant les données
String[] dataFile;
//classe Jeu
Jeu[] jeu;
//nombre de jeux à afficher + 1
int TOP_VISIBLE = 16;
float[] maxes;
int[] unitChoices;
int[] scales;
float ligne;
String[] dates;
int date;
//variables d'affichage
String date_affichage;
int partie_affichage;
boolean affichageRecap = false;

//taille de la vidéo créée
float X_ECRAN = 1520;
float Y_ECRAN = 855;

//variables de taille
float X_MIN = 15;
float X_MAX = X_ECRAN;
float Y_MIN = 100;
float Y_MAX = Y_ECRAN-0;
float X_W = X_MAX-X_MIN;
float Y_H = Y_MAX-Y_MIN;
float BAR_PROPORTION = 0.9;

float currentScale = -1;

int frames = 0;
int framesRecap = 0;
float currentDay = 0;
float BAR_HEIGHT;
PFont font;
/*
Vitesse d'enregistrement : 30 fps
Pour toutes les parties : 
Si FRAMES_PER_DAY = 30, 1 s/jour <=> 1 jour/s (au 30/09/21, durée totale : 34 min 50 s)
Si FRAMES_PER_DAY = 3, 0,1 s/jour <=> 10 jours/s (au 30/09/21, durée totale : 3 min 29 s)
Pour une seule année : 
Si FRAMES_PER_DAY = 15, 1 s/jour <=> 1 jour/s, durée totale : 3 min 03 s
Si FRAMES_PER_DAY = 5, 1 s/jour <=> 1 jour/s, durée totale : 1 min 01 s
Si FRAMES_PER_DAY = 3, 0,1 s/jour <=> 10 jours/s, durée totale : 36 s
*/
float FRAMES_PER_DAY = 1;
//unités utilisées pour l'axe
int[] unitPresets = {1,2,5,10,20,50,100,200,500,1000};
//variable pour l'exportation de la vidéo
VideoExport videoExport; 


void setup(){
  font = loadFont("ProcessingSansPro-Regular-96.vlw");
  //choix des couleurs utilisées pour les barres
  randomSeed(432766);
  dataFile = loadStrings("/data/parties.csv");
  /*Récupération des lignes du fichier,
  calcul du nombre de jeux (colonnes-1) et du nombre de jours (lignes-1)*/
  String[] parts = dataFile[0].split(";");
  NOMBRE_JOURS = dataFile.length-1;
  NOMBRE_JEUX = parts.length-1;
  dates = new String[NOMBRE_JOURS];
  
  //initialisation des max journaliers
  maxes = new float[NOMBRE_JOURS];
  unitChoices = new int[NOMBRE_JOURS];
  //unitChoices = new int[DAY_LEN];
  for(int d = 0; d < NOMBRE_JOURS; d++){
    maxes[d] = 0;
  }

  //instanciation
  jeu = new Jeu[NOMBRE_JEUX];
  for(int i = 0; i < NOMBRE_JEUX; i++){
    jeu[i] = new Jeu(parts[i+1]);
  }  
  
  for(int d = 0; d < NOMBRE_JOURS; d++){
    String[] dataParts = dataFile[d+1].split(";");
    dates[d] = dataParts[0];
    for(int p = 0; p < NOMBRE_JEUX; p++){
      //enregistrement du nombre cumulé de parties, par jeu et par jour
      float val = Float.parseFloat(dataParts[p+1]);
      jeu[p].parties[d] = val;
      if(val > maxes[d]){
        //mise à jour du max journalier
        maxes[d] = val;
      }
    }
  }
  
  getRankings();
  getUnits();
  //calcul de la hauteur des bares et taille de la vidéo
  BAR_HEIGHT = (rankToY(1)-rankToY(0))*BAR_PROPORTION;
  size(1520,854);
  
  //instanciation rendu vidéo
  videoExport = new VideoExport(this, "vidéo_parties.mp4");
  videoExport.forgetFfmpegPath();
  videoExport.startMovie();
}

//jour de départ de l'enregistrement
/*
01/01/2020 : 1460
31/12/2020 : 1824
31/12/2021 : 2192
*/
int START_DAY = 0;
void draw(){
  if (affichageRecap){
    framesRecap++;
  }else{
    int START = 0;
    currentDay = getDayFromFrameCount(frames);
    currentScale = getXScale(currentDay);
    drawBackground();
    drawHorizTickmarks();
    drawbars();
    saveVideoFrameHamoid();
    frames++;
  }
}

void saveVideoFrameHamoid(){
  videoExport.saveFrame();
  //si on a dépassé le nombre total de jour, fin de l'enregistrement
  if(getDayFromFrameCount(frames+1) >= NOMBRE_JOURS){
    //v.1
    /*videoExport.endMovie();
    exit();*/
    //v.2
    Recap();
    println("fin de l'enregistrement");
    videoExport.endMovie();
    exit();
  }
}

void Recap(){
 //ICI
 println("écran récap");
 //on vide l'écran
 background(0);
 
 ecranRecap();
 //videoExport.endMovie();
 //println("fin de l'enregistrement");
 //exit();
 
}

void ecranRecap(){
  text(date_affichage,100,50);
  textAlign(CENTER);
  textFont(font,48);
}

float getDayFromFrameCount(int fc){
 return fc/FRAMES_PER_DAY+START_DAY;
}

void getUnits(){
  for(int d = 0; d < NOMBRE_JOURS; d++){
    float Xscale = getXScale(d);
    for (int u = 0; u < unitChoices.length; u++){
      if (unitPresets[u] >= Xscale/4.0){ // unité trop grande pour ce jour
        unitChoices[d] = u-1; // on sélectionne l'unité précédente
        break;
      }
    }
  }  
}

//Détermination de l'unité à utiliser
void drawHorizTickmarks(){
  float preferredUnit = WAIndex(unitChoices, currentDay, 4);
  if(preferredUnit == -1) {
    preferredUnit = 0;
  }
  float unitRem = preferredUnit%1.0;
  if(unitRem < 0.001){
    unitRem = 0;
  }else if(unitRem >= 0.999){
    unitRem = 0;
    preferredUnit = ceil(preferredUnit);
  }
  
  int thisUnit = unitPresets[(int)preferredUnit];
  int nextUnit = unitPresets[(int)preferredUnit+1];

  drawTickMarksOfUnit(thisUnit,255-unitRem*255);
  if(unitRem >=0.001){
    drawTickMarksOfUnit(nextUnit,unitRem*255);
  }
}

//Tracé de l'échelle et des barres verticales
void drawTickMarksOfUnit(int u, float alpha){
  for(int v = 0; v < currentScale*1.4; v+=u){
    float x = valueToX(v);
    fill(100,100,100,alpha);
    float W = 2;
    rect(x-W/2,Y_MIN+20,W,Y_H+20);
    textAlign(CENTER);
    textFont(font,62);
    text(v,x,Y_MIN+5);
  }
}


void drawBackground(){
  background(0);
  //Affichage de la date et de la légende
  date = (int)currentDay;
  date_affichage = dates[date];
  text(date_affichage,100,50);
  textAlign(CENTER);
  textFont(font,48);
  text("Nombre de parties : ",600,Y_MIN-50);
}

//Tracé des barres pour les jeux et affichage du texte
void drawbars(){
  noStroke();
  for(int p = 0; p < NOMBRE_JEUX; p++){
    Jeu je = jeu[p];
    if(je.parties[date] > 0){
      float val = linIndex(je.parties,currentDay);
    float x = valueToX(val);
    float rang = WAIndex(je.rangs, currentDay, 5);
    float y = rankToY(rang);
    fill (je.c);
    rect(X_MIN,y,x-X_MIN,BAR_HEIGHT);
    fill(255);
    textFont(font,28);
    partie_affichage = (int)je.parties[date];
    textAlign(LEFT);
    text(je.nom+" : "+partie_affichage,X_MIN+6,y+BAR_HEIGHT-6);
    date = (int)currentDay;
    }
  } 
}

void getRankings() {
  for(int d = 0; d < NOMBRE_JOURS; d++){
      boolean[] taken = new boolean[NOMBRE_JEUX];
      for (int p = 0; p < NOMBRE_JEUX; p++){
        taken[p] = false;
      }
      for (int spot = 0; spot < TOP_VISIBLE; spot++){
        float record = -1;
        int holder = -1;
        //détermiantion du détenteur du record
        for (int p = 0; p < NOMBRE_JEUX; p++){
          if(!taken[p]){
            float val = jeu[p].parties[d];
            if(val > record){
              record = val;
              holder = p;
            }
          }
        }
        jeu[holder].rangs[d] = spot+1;
        taken[holder] = true;
      }
  }
}

float linIndex(float[] a, float index){
  int indexInt = (int)index;
  float indexRem = index%1.0;
  float beforeVal = a[indexInt];
  float afterVal = a[min(NOMBRE_JOURS-1,indexInt+1)];
  return lerp(beforeVal,afterVal,indexRem);
}

//calcul de la moyenne pondérée
float WAIndex(float[] a, float index, float WINDOW_WIDTH){
  int startIndex = max(0,ceil(index-WINDOW_WIDTH));
  int endIndex = min(NOMBRE_JOURS-1,floor(index+WINDOW_WIDTH));
  float counter = 0;
  float summer = 0;  
  for(int d = startIndex; d <= endIndex; d++){
    float val = a[d];
    float weight = 0.5+0.5*cos((d-index)/WINDOW_WIDTH*PI);
    counter += weight;
    summer += val*weight;
  }
  float finalResult = summer/counter;
  return finalResult;
}

float WAIndex(int[] a, float index, float WINDOW_WIDTH){
  float[] aFloat = new float[a.length];
  for(int i = 0; i < a.length; i++){
    aFloat[i] = a[i];
  }
  return WAIndex(aFloat,index,WINDOW_WIDTH);
}

float getXScale(float d){
  return WAIndex(maxes,d,14)*1.1;
}

//calcul de x
float valueToX(float val){
  return X_MIN+X_W*val/currentScale;
}

//calcul de y
float rankToY(float rank) {
  float y = Y_MIN+rank*(Y_H/TOP_VISIBLE);
  return y;
}
