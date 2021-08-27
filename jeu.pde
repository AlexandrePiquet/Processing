class Jeu{
  String nom;
  float[] parties = new float[NOMBRE_JOURS];
  int[] rangs = new int[NOMBRE_JOURS];
  color c;
  public Jeu(String n){
    nom = n;
    for(int i = 0; i < NOMBRE_JOURS; i++){
      parties[i] = 0;
      rangs[i] = TOP_VISIBLE+3;
    }
    c = color(random(50,200),random(50,200),random(50,200));
  }
}
