class Jeu{
  String nom;
  String nomImage;
  PImage image;
  PImage image2;
  float[] parties = new float[NOMBRE_JOURS];
  int[] rangs = new int[NOMBRE_JOURS];
  color c;
  public Jeu(String n){
    nom = n;
    for(int i = 0; i < NOMBRE_JOURS; i++){
      parties[i] = 0;
      rangs[i] = TOP_VISIBLE+3;
      if (utilisationImage) {
        nomImage = "/home/home/Bureau/images/" + trim(nom.replace(" ", "_")) + ".jpg";
        image = loadImage(nomImage);
      }
    }
    c = color(random(50,200),random(50,200),random(50,200));
  }
}
