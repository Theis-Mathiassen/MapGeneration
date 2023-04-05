import java.util.Comparator;

class Vertex {
    public int x;
    public int y;
    public int distance;

    public Vertex(int x, int y, int distance) {
        this.x = x;
        this.y = y;
        this.distance = distance;
    }
}

int[][] dijkstraMap(byte[][] map, int startX, int startY) {
    int width = map.length;
    int height = map[0].length;
    int[][] distances = new int[width][height];
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
            distances[x][y] = Integer.MAX_VALUE;
        }
    }
    distances[startX][startY] = 0;

    Comparator<Vertex> distanceComparator = new Comparator<Vertex>() {
        public int compare(Vertex v1, Vertex v2) {
            return v1.distance - v2.distance;
        }
    };
    PriorityQueue<Vertex> queue = new PriorityQueue<Vertex>(distanceComparator);
    queue.add(new Vertex(startX, startY, 0));

    while (!queue.isEmpty()) {
        Vertex current = queue.poll();

        int x = current.x;
        int y = current.y;
        int distance = current.distance;

        if (map[x][y] == 0) {
            continue;
        }

        if (distance > distances[x][y]) {
            continue;
        }

        for (int dx = -1; dx <= 1; dx++) {
            for (int dy = -1; dy <= 1; dy++) {
                if (dx == 0 && dy == 0 || !(dx == 0 || dy == 0)) {
                    continue;
                }

                int neighborX = x + dx;
                int neighborY = y + dy;

                if (neighborX < 0 || neighborX >= width || neighborY < 0 || neighborY >= height) {
                    continue;
                }
                if (map[neighborX][neighborY] == 0) {
                    continue;
                }

                int neighborDistance = distance + abs(dx) + abs(dy);

                if (neighborDistance < distances[neighborX][neighborY]) {
                    distances[neighborX][neighborY] = neighborDistance;
                    queue.add(new Vertex(neighborX, neighborY, neighborDistance));
                }
            }
        }
    }
    for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          if (distances[x][y] == Integer.MAX_VALUE) {
            distances[x][y] = 0;
          }
        }
    }

    return distances;
}
