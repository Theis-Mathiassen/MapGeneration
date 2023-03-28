//final int sizeX = 2500;
//final int sizeY = 1300;
Camera MainCamera;
Camera cameraVoronoi;
Map MainMap = new Map();

//Generators
//Drunk drunk = new Drunk(MainMap,MainMap.tilesX * 2 / 4, MainMap.tilesY * 2 / 4, 30, true);
Drunk drunk2;
Drunk drunk21;
//Drunk drunk3 = new Drunk(MainMap,MainMap.tilesX * 3 / 4, MainMap.tilesY * 1 / 4, 20, false);
//Drunk drunk4 = new Drunk(MainMap,10, 10, 10, false);
DrunkPath CastleToCave;



Voronoi voronoiGenerator;

CellularAutomata Cell1;
WhiteNoise HighNoise;

CellularAutomata Cell2;
WhiteNoise LowNoise;

CellularAutomata Cell3;
WhiteNoise LowNoise2;

Prefab Castle;
Prefab Cave;

//Player
ArrayList<GameObject> GameObjects = new ArrayList<GameObject>();
Player player;





void setup () {
  size(2000, 1000, P2D);
  MainCamera = new Camera(0,0,width,height, 255);
  cameraVoronoi = new Camera(0,0,width,height, 128);
  frameRate(60);
  noStroke();
  background(0);
  randomSeed(0);
  
  player = new Player(MainMap, 236, 200);
  
  drunk2 = new Drunk(MainMap,130, 120, 90000, true, true);
  Drunk drunk21 = new Drunk(MainMap,130, 120, 40000, true, true);
  CastleToCave = new DrunkPath(MainMap, new Vector2[]{new Vector2(130,120),new Vector2(230,50), new Vector2(399, 160)}, 50,50,true, 5);
  
  Cell1  = new CellularAutomata(MainMap,6,5,9,5);
  HighNoise = new WhiteNoise(MainMap, 0.6, 4);
  
  Cell2  = new CellularAutomata(MainMap,3,3,9,3);
  LowNoise = new WhiteNoise(MainMap, 0.3, 1);
  
  Cell3  = new CellularAutomata(MainMap,4,3,9,3);
  WhiteNoise LowNoise2 = new WhiteNoise(MainMap,0.6, 1);
  
  voronoiGenerator = new Voronoi(MainMap, 5, true, true);
  
  PImage CastleIMG = loadImage("Castle.png");
  byte[][] CastleSCH = new byte[0][0];
  if (CastleIMG != null) {
    CastleSCH = Img2Schematic(CastleIMG);
  }
  Castle = new Prefab(MainMap, 30, 30,CastleSCH,true);
  
  PImage CaveImage = loadImage("Outpost.png");
  byte[][] CaveSCH = new byte[0][0];
  if (CaveImage != null) {
    CaveSCH = Img2Schematic(CaveImage);
  }
  Cave = new Prefab(MainMap, 400, 150,CaveSCH,true);
  
  
  //drunk.ChildGenerators.add(drunk2);
  //drunk.ChildGenerators.add(drunk3);
  //drunk.ChildGenerators.add(Cell);
  //drunk2.ChildGenerators.add(drunk4);
  Castle.ChildGenerators.add(Cave);
  
  //Cave.ChildGenerators.add(CastleToCave);
  //CastleToCave.ChildGenerators.add(ng);
  //ng.ChildGenerators.add(Cell);
  Cave.ChildGenerators.add(voronoiGenerator);
  
  HighNoise.ChildGenerators.add(Cell1);
  voronoiGenerator.addGeneratorToCell(0, HighNoise);
  
  LowNoise.ChildGenerators.add(Cell2);
  voronoiGenerator.addGeneratorToCell(1, LowNoise);
  
  LowNoise2.ChildGenerators.add(Cell3);
  voronoiGenerator.addGeneratorToCell(2, LowNoise2);
  
  drunk21.pos.x = voronoiGenerator.cells[3].pos.x;
  drunk21.pos.y = voronoiGenerator.cells[3].pos.y; //<>// //<>//
  voronoiGenerator.addGeneratorToCell(3, drunk21);
  drunk2.pos.x = voronoiGenerator.cells[4].pos.x;
  drunk2.pos.y = voronoiGenerator.cells[4].pos.y;
  voronoiGenerator.addGeneratorToCell(4, drunk2);
  
  
  
  Cave.ChildGenerators.add(CastleToCave);
  
  Castle.Generate();
  //voronoiGenerator.Generate(); //<>// //<>// //<>//
  

  //cameraVoronoi.DrawMap(MainMap, true);
  //MainCamera.DrawMap(MainMap, false);
  
  
  //MZ = new MazeSolver(MainMap.GetGrid());
  //MZ.traverse(30, 30);
  
  background(0);
  cameraVoronoi.DrawMap(MainMap, true);
  MainCamera.DrawMap(MainMap, false);
  save("mapDrunkardsPath.png");
  GameObjects.add(player);
  GameObjects.add(new Enemy(new Vector2(185, 210), MainMap));
  
}
/*int igen = 0;
void GenerateNext () {
  voronoiGenerator.ChildGenerators.get(igen).Generate();
  igen++;
  
  MainCamera.DrawGrid(MainMap.Locked, MainMap.tileSizeX);
}*/

void draw () {
  background(0);
  //cameraVoronoi.DrawMap(MainMap, true);
  MainCamera.DrawMap(MainMap, false);
  //MainCamera.DrawGrid(MainMap.Locked, MainMap.tileSizeX);
  for (int i = GameObjects.size() - 1; i >= 0; i--) {
    GameObject object = GameObjects.get(i);
    object.Update();
    MainCamera.DrawObject(object);
  }
  MainCamera.MoveTo(player);
  
  //print(player.pos.x + "," + player.pos.y + "\n");
  
  //text(frameRate,5,10);
}


byte[][] Img2Schematic (PImage img) {
  byte[][] result = new byte[img.width][img.height];
  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      //print(img.pixels[x*img.height + y]);
      int loc = x + y * img.width;
      if (img.pixels[loc] == -1) {
        result[x][y] = 1;
      }
      else {
        result[x][y] = 0;
      }
    }
  }
  return result;
}

void mousePressed () {
  //print(Cell.GetNeighbors((int)(mouseX - MainCamera.Pos.x) / MainMap.tileSizeX, (int)(mouseY - MainCamera.Pos.y) / MainMap.tileSizeY, MainMap.GetGrid()));
  //GenerateNext();
}
void keyPressed() {
    if (key >= 0 && key < 128) {
      InputSystem.keys[key] = 1;
    }
  }
  void keyReleased () {
    if (key >= 0 && key < 128) {
      InputSystem.keys[key] = 0;
    }
  }
