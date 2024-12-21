// Conways Game of life Written in Odin
package main

import rl "vendor:raylib"
import "core:fmt"
import "core:math/rand"

// Constants
SCREEN_WIDTH  :: 360 * 3
SCREEN_HEIGHT :: 240 * 3
CELL_SIZE     :: 10
GRID_SIZE_X   :: SCREEN_WIDTH / CELL_SIZE
GRID_SIZE_Y   :: SCREEN_HEIGHT / CELL_SIZE

// Initialize Game variables
grid : [GRID_SIZE_Y][GRID_SIZE_X]int = {}
new_grid : [GRID_SIZE_Y][GRID_SIZE_X]int = {}
doa : [2]int = {0,1}
generation : int = 0


// Procedures
main :: proc() {
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Odin's Way of life");
    rl.SetTargetFPS(60)
    
    // Populate the grid with random cells
    populate_grid(&grid)

    for !rl.WindowShouldClose() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

	// Current generation of grid
	for y in 0..<GRID_SIZE_Y {
	    for x in 0..<GRID_SIZE_X {
		if grid[y][x] == 1 {
                    rl.DrawRectangle(i32(x * CELL_SIZE), i32(y * CELL_SIZE), CELL_SIZE, CELL_SIZE, rl.WHITE);
		}
	    }
	}

	// Applies rules for next generation of grid
	apply_rules(&grid, &new_grid)

	// Draw new grid
	update_grid(&grid, &new_grid)

	rl.EndDrawing()
    }

    rl.CloseWindow()
    
}

// Populate the grid for the game
populate_grid :: proc(g: ^[GRID_SIZE_Y][GRID_SIZE_X]int) {

    for i := 0; i < GRID_SIZE_Y; i += 1 {
	for j := 0; j < GRID_SIZE_X; j += 1 {
	    g[i][j] = rand.choice(doa[:])
	}
    }

}

// Counts the live neighbors in all directions and returns the count
count_neighbors :: proc(g: ^[GRID_SIZE_Y][GRID_SIZE_X]int, x: int, y :int ) -> int {
    
    count := 0

    for i := -1; i <= 1; i += 1 {
	for j := -1; j <= 1; j += 1 {
	    if i == 0 && j == 0 { continue } // dont count ourself
	    nx : int = (x + i + GRID_SIZE_X) % GRID_SIZE_X
	    ny : int = (y + j + GRID_SIZE_Y) % GRID_SIZE_Y
	    count += g[ny][nx]
	}
    }

    return count
}

// Applies the rules of conways game of life to the cell based on neighbor count
apply_rules :: proc(g: ^[GRID_SIZE_Y][GRID_SIZE_X]int, ng: ^[GRID_SIZE_Y][GRID_SIZE_X]int) {
    for y := 0; y < GRID_SIZE_Y; y += 1 {
	for x := 0; x < GRID_SIZE_X; x += 1 {
	    neighbors := count_neighbors(g, x, y)
	    if g[y][x] == 1 && (neighbors == 2 || neighbors == 3) {
		ng[y][x] = 1 // Lives 
	    }
	    else if g[y][x] == 0 && neighbors == 3 {
		ng[y][x] = 1 // Born 
	    }
	    else {
		ng[y][x] = 0 // Death
	    }
	}
    }
}

// Update and draw the grid
update_grid :: proc(g: ^[GRID_SIZE_Y][GRID_SIZE_X]int, ng: ^[GRID_SIZE_Y][GRID_SIZE_X]int) {
    for y in 0..<GRID_SIZE_Y {
	for x in 0..<GRID_SIZE_X {
	    g[y][x] = ng[y][x]
	}
    }
}


