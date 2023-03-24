//final int sizeX = 2500;
//final int sizeY = 1300;
Camera MainCamera;
Camera cameraVoronoi;
Map MainMap = new Map();

//Generators
//Drunk drunk = new Drunk(MainMap,MainMap.tilesX * 2 / 4, MainMap.tilesY * 2 / 4, 30, true);
Drunk drunk2 = new Drunk(MainMap,130, 120, 20000, true, true);
Drunk drunk21 = new Drunk(MainMap,130, 120, 20000, true, true);
//Drunk drunk3 = new Drunk(MainMap,MainMap.tilesX * 3 / 4, MainMap.tilesY * 1 / 4, 20, false);
//Drunk drunk4 = new Drunk(MainMap,10, 10, 10, false);
//DrunkPath CastleToCave = new DrunkPath(MainMap, new Vector2[]{new Vector2(130,120), new Vector2(229, 60)}, 50,50,true);



Voronoi voronoiGenerator;

CellularAutomata Cell  = new CellularAutomata(MainMap,7,5,9,5);

WhiteNoise ng = new WhiteNoise(MainMap,0.7);
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
  size(2000, 1000, P2D);
  MainCamera = new Camera(0,0,width,height, 128);
  cameraVoronoi = new Camera(0,0,width,height, 128);
  frameRate(60);
  noStroke();
  background(0);
  randomSeed(0);
  
  voronoiGenerator = new Voronoi(MainMap, 5, true, true);
  
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
  ng.ChildGenerators.add(Cell);
  
  //drunk2.ChildGenerators.add(voronoiGenerator);
  drunk2.pos.x = voronoiGenerator.cells[0].pos.x;
  drunk2.pos.y = voronoiGenerator.cells[0].pos.y;
  voronoiGenerator.addGeneratorToCell(0, drunk2);
  drunk21.pos.x = voronoiGenerator.cells[2].pos.x;
  drunk21.pos.y = voronoiGenerator.cells[2].pos.y; //<>// //<>//
  voronoiGenerator.addGeneratorToCell(2, drunk21);
  voronoiGenerator.Generate(); //<>// //<>//
  

  cameraVoronoi.DrawMap(MainMap, true);
  //MainCamera.DrawMap(MainMap, false);
  
  
  //MZ = new MazeSolver(MainMap.GetGrid());
  //MZ.traverse(30, 30);
  
  //CameraVoronoi.DrawMap(MainMap, true);
  //MainCamera.DrawMap(MainMap, false);
  //save("mapPath2.png");
  GameObjects.add(player);
  GameObjects.add(new Enemy(new Vector2(2100, 650), MainMap));
  
}
/*int igen = 0;
void GenerateNext () {
  voronoiGenerator.ChildGenerators.get(igen).Generate();
  igen++;
  
  MainCamera.DrawGrid(MainMap.Locked, MainMap.tileSizeX);
}*/

void draw () {
  background(0);
  cameraVoronoi.DrawMap(MainMap, true);
  MainCamera.DrawMap(MainMap, false);
  //MainCamera.DrawGrid(MainMap.Locked, MainMap.tileSizeX);
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
