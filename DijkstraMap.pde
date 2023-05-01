import java.util.Comparator;

class Vertex {
    public int x;
    public int y;
    public int distance;
    public Vertex prev;

    public Vertex(int x, int y, int distance, Vertex prev) {
        this.x = x;
        this.y = y;
        this.distance = distance;
        this.prev = prev;
    }
}

class DijkstraMap {
  int[][] distanceMap;
  Vertex[][] VertexMap;
  ArrayList<Vertex> path = new ArrayList<Vertex>();
  public DijkstraMap (int w, int h) {
    distanceMap = new int[w][h];
    for (int x = 0; x < w; x++) {
        for (int y = 0; y < h; y++) {
            this.distanceMap[x][y] = Integer.MAX_VALUE;
        }
    }
    VertexMap = new Vertex[w][h];
  }
  
  void calcMap (short[][] map, int startX, int startY) {
    dijkstraMap(this, map, startX, startY);
  }
  void calcDistanceToHotPath (short[][] map, int xfinish, int yfinish) {
    Vertex current = dijkstra.VertexMap[xfinish][yfinish];
    while(current.prev != null) {
      path.add(0,current);
      current = current.prev;
    }
    
    for (int i = 0; i < path.size(); i++) {
      dijkstra.calcMap(map, path.get(i).x, path.get(i).y);
    }
  }
  /*public DijkstraMap (DijkstraMap map) {
    int w = map.distanceMap.length;
    int h = map.distanceMap[0].length;
    distanceMap = new int[w][h];
    VertexMap = new Vertex[w][h];
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h;j++) {
        distanceMap[i][j] = map.distanceMap[i][j];
        VertexMap[i][j] = new Vertex(map.VertexMap[i][j].x, map.VertexMap[i][j].y, map.VertexMap[i][j].distance, map.VertexMap[i][j].prev);
      }
    }
  }*/
}




private void dijkstraMap(DijkstraMap dMap, short[][] map, int startX, int startY) {
  int w = map.length; //<>// //<>//
  int h = map[0].length;
  
  dMap.distanceMap[startX][startY] = 0;
  
  Comparator<Vertex> distanceComparator = new Comparator<Vertex>() {
        public int compare(Vertex v1, Vertex v2) {
            return v1.distance - v2.distance;
        }
    };
    PriorityQueue<Vertex> queue = new PriorityQueue<Vertex>(distanceComparator);
    if(dMap.VertexMap[startX][startY] != null) {
      dMap.VertexMap[startX][startY].distance = 0;
      queue.add(dMap.VertexMap[startX][startY]);
    } else {
      queue.add(new Vertex(startX, startY, 0, null));
    }
    
    while (!queue.isEmpty()) {
        Vertex current = queue.poll();

        int x = current.x;
        int y = current.y;
        int distance = current.distance;

        if (map[x][y] == 0) {
            continue;
        }

        if (distance > dMap.distanceMap[x][y]) {
            continue;
        }

        for (int dx = -1; dx <= 1; dx++) {
            for (int dy = -1; dy <= 1; dy++) {
                if (dx == 0 && dy == 0 || !(dx == 0 || dy == 0)) {
                    continue;
                }

                int neighborX = x + dx;
                int neighborY = y + dy;

                if (neighborX < 0 || neighborX >= w || neighborY < 0 || neighborY >= h) {
                    continue;
                }
                if (map[neighborX][neighborY] == 0) {
                    continue;
                }

                int neighborDistance = distance + map[neighborX][neighborY];

                if (neighborDistance < dMap.distanceMap[neighborX][neighborY]) {
                    dMap.distanceMap[neighborX][neighborY] = neighborDistance;
                    
                    dMap.VertexMap[neighborX][neighborY] = new Vertex(neighborX, neighborY, neighborDistance, current);
                    queue.add(dMap.VertexMap[neighborX][neighborY]);
                }
            }
        }
    }
}
