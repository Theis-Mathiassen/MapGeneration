//final int sizeX = 2500;
//final int sizeY = 1300;
Camera MainCamera;
Map MainMap = new Map();

//Generators
//Drunk drunk = new Drunk(MainMap,MainMap.tilesX * 2 / 4, MainMap.tilesY * 2 / 4, 30, true);
//Drunk drunk2 = new Drunk(MainMap,130, 120, 2000000, true);
//Drunk drunk3 = new Drunk(MainMap,MainMap.tilesX * 3 / 4, MainMap.tilesY * 1 / 4, 20, false);
//Drunk drunk4 = new Drunk(MainMap,10, 10, 10, false);
//DrunkPath CastleToCave = new DrunkPath(MainMap, new Vector2[]{new Vector2(130,120), new Vector2(229, 60)}, 50,50,true);



Voronoi voronoiGenerator;

//CellularAutomata Cell  = new CellularAutomata(MainMap,7,5,9, 5);

//WhiteNoise ng = new WhiteNoise(MainMap,0.7);
//Prefab Castle;
//Prefab Cave;

//Player
ArrayList<GameObject> GameObjects = new ArrayList<GameObject>();
Player player = new Player(MainMap, MainMap.tileSizeX * 130, MainMap.tileSizeX * 120);

MazeSolver MZ;

float NoiseZoom = 0.1;

//MazeSolver maze = new MazeSolver(grid);
//boolean solved = maze.solve();



void setup () {
  size(2500, 1300, P2D);
  MainCamera = new Camera(0,0,width,height);
  //CameraVoronoi = new Camera(0,0,width,height, 255);
  frameRate(60);
  noStroke();
  background(0);
  randomSeed(0);
  
  voronoiGenerator = new Voronoi(MainMap, 15, true, true);
  
  /*PImage CastleIMG = loadImage("Castle.png");
  byte[][] CastleSCH = new byte[0][0];
  if (CastleIMG != null) {
    CastleSCH = Img2Schematic(CastleIMG);
  }
  Castle = new Prefab(MainMap, 30, 30,CastleSCH,true);
  
  PImage CaveImage = loadImage("Cave.png");
  byte[][] CaveSCH = new byte[0][0];
  if (CaveImage != null) {
    CaveSCH = Img2Schematic(CaveImage);
  }
  Cave = new Prefab(MainMap, 230, 50,CaveSCH,true);*/
  
  
  //drunk.ChildGenerators.add(drunk2);
  //drunk.ChildGenerators.add(drunk3);
  //drunk.ChildGenerators.add(Cell);
  //drunk2.ChildGenerators.add(drunk4);
  //Castle.ChildGenerators.add(Cave);
  //Cave.ChildGenerators.add(CastleToCave);
  //CastleToCave.ChildGenerators.add(ng);
  //ng.ChildGenerators.add(Cell);
  
  //drunk2.ChildGenerators.add(voronoiGenerator);
  voronoiGenerator.Generate();
  
  
  //MZ = new MazeSolver(MainMap.GetGrid());
  //MZ.traverse(30, 30);
  
  //CameraVoronoi.DrawMap(MainMap, true);
  //MainCamera.DrawMap(MainMap, false);
  //save("mapPath2.png");
  GameObjects.add(player);
  GameObjects.add(new Enemy(new Vector2(2100, 650), MainMap));
  
}

void draw () {
  //background(0);
  MainCamera.DrawMap(MainMap, true);
  for (int i = GameObjects.size() - 1; i >= 0; i--) {
    GameObject object = GameObjects.get(i);
    object.Update();
    //MainCamera.DrawObject(object);
  }
  //MainCamera.MoveTo(player);
  
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
