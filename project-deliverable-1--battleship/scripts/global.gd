extends Node

var nextSceneToLoad: String = ""

var isPlayerOneTurn: bool = true

# There are 4 boards in total:
#	Player 1 ships = index 0
#	Player 1 shots = index 1
#	Player 2 ships = index 2
#	Player 2 shots = index 3
var boardstates = []

var shipStates = []

const NUMBER_OF_BOARDS = 4

const GRID_SIZE: Vector2 = Vector2(10, 10)

enum Boats{DESTROYER, SUBMARINE_OR_CRUISER, BATTLESHIP, CARRIER}

enum BoatIds{DESTROYER, SUBMARINE, CRUISER, BATTLESHIP, CARRIER}

signal setup_boat_selected(boat: Boats)

#Setup screen variables
var isPlacingBoat: bool = false
var isPlacementValid : bool = false

#Firing variables
var isTargeting: bool = false
var isTargetValid: bool = false
var targetedTile: Vector2

signal setup_tile_focused_boat(coords: Vector2)
signal place_boat_at_tile(coords: Vector2)
signal target_preview(coords: Vector2)
signal target_locked(coords: Vector2)

func _init():
	
	AudioPlayer.play()
	boardstates.resize(NUMBER_OF_BOARDS)
	for n in NUMBER_OF_BOARDS:
		boardstates[n] = []
		boardstates[n].resize(GRID_SIZE.x)
		for x in GRID_SIZE.x:
			boardstates[n][x] = []
			boardstates[n][x].resize(GRID_SIZE.y)
			for y in GRID_SIZE.y:
				boardstates[n][x][y] = null

func setup_ship_states():
	shipStates.resize(2)
	for n in shipStates:
		shipStates[n] = []
		shipStates[n].resize(5)
		for x in shipStates[n]:
			shipStates[n][x] = false
			
func clicking_btn_sound() -> void:
	var click_sound = load("res://assets/sounds/pen-click-99025.mp3")
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("rotate_boat"):
		AudioPlayer.playOnce(click_sound)
