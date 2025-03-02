extends Control

var placementGridArrays = []

var shipButtons = []
var currentBoard
const BOARDS: int = 2 

#var boatBack = load("res://assets/boat-back-(128x128).png")
#var boatMiddle = load("res://assets/boat-middle-(128x128).png")
#var boatFront = load("res://assets/boat-front-(128x128).png")
#
#var bgWater = load("res://assets/bg-water-(128x128).png")
#var oppBg = load("res://assets/opponent-bg-(128x128).png")
#

var target = load("res://assets/target-(128x128).png")
var hit = load("res://assets/hit-(128x128).png")
var missed = load("res://assets/miss-(128x128).png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.target_preview.connect(tile_targeted.bind())
	Global.target_locked.connect(tile_locked.bind())
	
	#	Determine if it is player One's turn and then set currentBoard
#	to appropriate boardstate
	if(Global.isPlayerOneTurn):
		currentBoard = 0
	else:
		currentBoard = 2
		
#	Creating a new gridcontainer instance for all the battle grid
	var player_grid = get_node("VBoxContainer/PlayerBoardContainer/MarginContainer/HBoxContainer/player_board")
	var shooting_grid = get_node("VBoxContainer/PlayerBoardContainer/MarginContainer/HBoxContainer/shooting_board")
	
	var gridArray = [player_grid]
	
	var btnScript = load("res://scripts/setup_grid_btn.gd")
		
	placementGridArrays.resize(2)
	for n in BOARDS:
		#placementGridArrays[n] = Global.boardstates[n+currentBoard].duplicate(true)
		placementGridArrays[n] = []
		placementGridArrays[n].resize(10)
		#shipButtons.resize(10)
		for x in Global.GRID_SIZE.x:
			placementGridArrays[n][x] = []
			placementGridArrays[n][x].resize(10)
			for y in Global.GRID_SIZE.y:
				if n == 0:
					var clonedBtn = ShipsBtn.new()
					clonedBtn.clone(Global.boardstates[n+currentBoard][x][y])
					placementGridArrays[n][x][y] = clonedBtn
					player_grid.add_child(clonedBtn)
				else:
					var clonedBtn = ShotsBtn.new()
					clonedBtn.clone(Global.boardstates[n+currentBoard][x][y])
					placementGridArrays[n][x][y] = clonedBtn
					shooting_grid.add_child(clonedBtn)
					
				if x == 0 and y == 0 and n == 1:
					placementGridArrays[n][x][y].grab_focus()
					tile_targeted(Vector2(x, y))
	
	Global.isTargeting = true
	
	for n in 6:
		if _is_boat_destroyed_by_id(n):
			print("BOAT DESTROYED BY ID TRUE")
			print(n)
			var boatType = _get_boat_type_by_id(n)
			_disable_ship_btn(boatType)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.clicking_btn_sound()

func tile_targeted(coord: Vector2) -> void: 
	var is_valid_target: bool = _is_target_valid(coord)
	if is_valid_target:
		placementGridArrays[1][coord.x][coord.y].texture_focused = target
		placementGridArrays[1][coord.x][coord.y].texture_normal = target
		
	
func tile_locked(coord: Vector2) -> void: 
	Global.isTargeting = false
	Global.targetedTile = coord
	var fire_btn = get_node("VBoxContainer/FireBtn/MarginContainer/FireButton")
	fire_btn.disabled = false
	fire_btn.grab_focus()
	
	
func _is_target_valid(coord: Vector2) -> bool:
	if !placementGridArrays[1][coord.x][coord.y].shots_fired_at_tile and !placementGridArrays[1][coord.x][coord.y].disabled :
		return true
	else: 
		return false
		


func _on_fire_button_pressed() -> void:
	var coord = Global.targetedTile
	if Global.boardstates[(currentBoard + 2) % 4][coord.x][coord.y].hasBoat:
		placementGridArrays[1][coord.x][coord.y].texture_normal = hit
		placementGridArrays[1][coord.x][coord.y].texture_focused = hit
		placementGridArrays[1][coord.x][coord.y].shots_fired_at_tile = true
		placementGridArrays[1][coord.x][coord.y].disabled = true
		Global.boardstates[(currentBoard + 2) % 4][coord.x][coord.y].has_been_shot = true
		Global.boardstates[(currentBoard + 2) % 4][coord.x][coord.y].texture_normal = hit
		Global.boardstates[(currentBoard + 2) % 4][coord.x][coord.y].texture_focused = hit
		if _is_boat_destroyed(coord):
			print("BOAT DESTROYED")
			_disable_ship_btn(Global.boardstates[(currentBoard + 2) % 4][coord.x][coord.y].boat)
			_check_if_all_boats_dead()
			if _check_if_all_boats_dead():
				var timer := Timer.new()
				add_child(timer)
				timer.wait_time = 3.0
				timer.one_shot = true
				timer.start()
				timer.connect("timeout", _on_timer_timeout)
				
			
	else: 
		placementGridArrays[1][coord.x][coord.y].texture_normal = missed
		placementGridArrays[1][coord.x][coord.y].texture_focused = missed
		placementGridArrays[1][coord.x][coord.y].shots_fired_at_tile = true
		placementGridArrays[1][coord.x][coord.y].disabled = true
	_init_ships_boards()
	_init_shots_boards()
	
func _init_shots_boards() -> void:
	var playerShotsBoard = []
	
	playerShotsBoard.resize(Global.GRID_SIZE.x)
	
	for x in Global.GRID_SIZE.x:
		playerShotsBoard[x] = []
		playerShotsBoard[x].resize(Global.GRID_SIZE.y)
		
		for y in Global.GRID_SIZE.y:
			playerShotsBoard[x][y] = ShotsBtn.new()
			playerShotsBoard[x][y].clone(placementGridArrays[1][x][y])
			
			
	Global.boardstates[currentBoard + 1] = playerShotsBoard.duplicate(true)
	
func _init_ships_boards() -> void:
	var playerShipsBoard = []
	
	playerShipsBoard.resize(Global.GRID_SIZE.x)
	
	for x in Global.GRID_SIZE.x:
		playerShipsBoard[x] = []
		playerShipsBoard[x].resize(Global.GRID_SIZE.y)
		
		for y in Global.GRID_SIZE.y:
			playerShipsBoard[x][y] = ShipsBtn.new()
			playerShipsBoard[x][y].clone(placementGridArrays[0][x][y])
				
	Global.boardstates[currentBoard] = playerShipsBoard.duplicate(true)

func _is_boat_destroyed(coord: Vector2) -> bool:
	print("_is_boat_destroyed called")
	var isDestroyed: bool = true
	for x in Global.GRID_SIZE.x:
		for y in Global.GRID_SIZE.y:
			if (Global.boardstates[(currentBoard + 2) % 4][x][y].boatID == Global.boardstates[(currentBoard + 2) % 4][coord.x][coord.y].boatID) and !Global.boardstates[(currentBoard + 2) % 4][x][y].has_been_shot:
				print("UNDESTROYED TILE at : %s, %s" % [x, y])
				isDestroyed = false
	return isDestroyed
	
func _is_boat_destroyed_by_id(id: int) -> bool:
	print("_is_boat_destroyed_by_id called")
	var isDestroyed: bool = true
	for x in Global.GRID_SIZE.x:
		for y in Global.GRID_SIZE.y:
			if (Global.boardstates[(currentBoard + 2) % 4][x][y].boatID == id) and !Global.boardstates[(currentBoard + 2) % 4][x][y].has_been_shot:
				isDestroyed = false
	return isDestroyed
	
func _get_boat_type_by_id(id: int) -> Global.Boats:
	print("get_boat type called")
	var isDestroyed: bool = true
	for x in Global.GRID_SIZE.x:
		for y in Global.GRID_SIZE.y:
			if (Global.boardstates[(currentBoard + 2) % 4][x][y].boatID == id):
				return Global.boardstates[(currentBoard + 2) % 4][x][y].boat
	return -1
	
	
func _disable_ship_btn(boat: Global.Boats) -> void:
	match boat:
		Global.Boats.DESTROYER:
			print("DESTROYER DESTROYED")
			var btn : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/DestroyerBtn")
			btn.disabled = true
		Global.Boats.SUBMARINE_OR_CRUISER:
			var btn : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/SubmarineBtn")
			if btn.disabled:
				print("CRUISER DESTROYED")
				btn = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/CruiserBtn")
				btn.disabled = true
			print("SUB DESTROYED")
			btn.disabled = true
		Global.Boats.BATTLESHIP:
			print("BATTLESHIP DESTROYED")
			var btn : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/Battleship")
			btn.disabled = true
		Global.Boats.CARRIER:
			print("CARRIER DESTROYED")
			var btn : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/Carrier")
			btn.disabled = true
		_:
			print("NO MATCH ON BOAT")

			
func _check_if_all_boats_dead() -> bool:
	
	var btn_destroyer : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/DestroyerBtn")
	var btn_submarine : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/SubmarineBtn")
	var btn_cruizer : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/CruiserBtn")
	var btn_battleship : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/Battleship")
	var btn_carrier : TextureButton = get_node("VBoxContainer/ShipsToPlace/MarginContainer/HBoxContainer/Carrier")
	
	if btn_destroyer.disabled and btn_submarine.disabled and btn_cruizer.disabled and btn_battleship.disabled and btn_carrier.disabled:
		return true
	
	return false
			
			
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
