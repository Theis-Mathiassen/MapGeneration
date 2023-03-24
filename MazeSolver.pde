public class MazeSolver {

    final static int TRIED = 2;
    final static int PATH = 3;
    
    private byte[][] grid;
    private int h;
    private int w;
    private int EndX;
    private int EndY;

    private int[][] map;

    public MazeSolver(byte[][] grid, int endX, int endY) {
        this.grid = grid;
        this.h = grid.length;
        this.w = grid[0].length;
        EndX = endX;
        EndY = endY;

        this.map = new int[h][w];
    }

    public boolean solve() {
        return traverse(0,0); //<>// //<>// //<>//
    }

    private boolean traverse(int i, int j) {
        if (!isValid(i,j)) { //<>// //<>// //<>//
            return false;
        }

        if ( isEnd(i, j) ) {
            map[i][j] = PATH;
            return true;
        } else {
            map[i][j] = TRIED;
        }

        // North
        if (traverse(i - 1, j)) {
            map[i-1][j] = PATH;
            return true;
        }
        // East
        if (traverse(i, j + 1)) {
            map[i][j + 1] = PATH;
            return true;
        }
        // South
        if (traverse(i + 1, j)) {
            map[i + 1][j] = PATH;
            return true;
        }
        // West
        if (traverse(i, j - 1)) {
            map[i][j - 1] = PATH;
            return true;
        }

        return false;
    }

    private boolean isEnd(int i, int j) {
        return i == EndX && j == EndY; //<>// //<>// //<>//
    }

    private boolean isValid(int i, int j) {
        if (inRange(i, j) && isOpen(i, j) && !isTried(i, j)) { //<>// //<>// //<>//
            return true;
        }

        return false;
    }

    private boolean isOpen(int i, int j) {
        return grid[i][j] == 1;
    }

    private boolean isTried(int i, int j) {
        return map[i][j] == TRIED;
    }

    private boolean inRange(int i, int j) {
        return inHeight(i) && inWidth(j);
    }

    private boolean inHeight(int i) {
        return i >= 0 && i < h;
    }

    private boolean inWidth(int j) {
        return j >= 0 && j < w;
    }
}
