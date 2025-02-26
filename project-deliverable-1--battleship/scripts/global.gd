extends Node

var isPlayerOneTurn: bool = true

# There are 4 boards in total:
#	Player 1 ships = index 0
#	Player 1 shots = index 1
#	Player 2 ships = index 2
#	Player 2 shots = index 3
var boardstates = []

const NUMBER_OF_BOARDS = 4

const GRID_SIZE: Vector2 = Vector2(10, 10)

enum Boats{DESTROYER, SUBMARINE_OR_CRUISER, BATTLESHIP, CARRIER}

signal setup_boat_selected(boat: Boats)

var isPlacingBoat: bool = false

signal setup_tile_focused_boat(coords: Vector2)

func _init():
	boardstates.resize(NUMBER_OF_BOARDS)
	for n in NUMBER_OF_BOARDS:
		boardstates[n] = []
		boardstates[n].resize(GRID_SIZE.x)
		for x in GRID_SIZE.x:
			boardstates[n][x] = []
			boardstates[n][x].resize(GRID_SIZE.y)
			for y in GRID_SIZE.y:
				boardstates[n][x][y] = null
				
