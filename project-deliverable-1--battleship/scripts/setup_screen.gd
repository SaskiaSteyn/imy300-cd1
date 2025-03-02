extends Control

var placementGridArray = []
var currentBoard
var selectedBoat: Global.Boats

#Direction of boat
#if false = horizontally, if true = vertically
var direction: bool = false

var amount_boats = 0
var boatID = 1

var boatBack = load("res://assets/boat-back-(128x128).png")
var boatMiddle = load("res://assets/boat-middle-(128x128).png")
var boatFront = load("res://assets/boat-front-(128x128).png")
var bgWater = load("res://assets/bg-water-(128x128).png")
var oppBg = load("res://assets/opponent-bg-(128x128).png")
var red_boat_back = load("res://assets/boat-hit-back-(128x128).png")
var red_boat_front = load("res://assets/boat-hit-front-(128x128).png")
var red_boat_middle = load("res://assets/boat-hit-middle-(128x128).png")
var vertical_back = load("res://assets/boat-back-(128x128)-90.png")
var vertical_middle = load("res://assets/boat-middle-(128x128)-90.png")
var vertical_front = load("res://assets/boat-front-(128x128)-90.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Connect listeners to button press events
	Global.setup_boat_selected.connect(boat_selected.bind())
	Global.setup_tile_focused_boat.connect(preview_boat_on_tile.bind())
	Global.place_boat_at_tile.connect(_place_boat_at_tile.bind())
	
#	Determine if it is player One's turn and then set currentBoard
#	to appropriate boardstate
	if(Global.isPlayerOneTurn):
		currentBoard = 0
	else:
		currentBoard = 2
		
#	Creating a new gridcontainer instance for all the battle grid
	var gridContainer = get_node("VBoxContainer/PlayerBoardContainer/MarginContainer/HBoxContainer/GridContainer")
	
	var btnScript = load("res://scripts/setup_grid_btn.gd")
		
	placementGridArray.resize(10)
	for x in Global.GRID_SIZE.x:
		placementGridArray[x] = []
		placementGridArray[x].resize(10)
		for y in Global.GRID_SIZE.y:
			
#			Initialise the new button and set all properties on it
			var newGridBtn = GridBtn.new()
			newGridBtn.init(Vector2(x,y))
			
#			Add the button to the grid container
			gridContainer.add_child(newGridBtn)
#			Add it to the 2d array to maintain a ref to the button
			placementGridArray[x][y] = newGridBtn
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.clicking_btn_sound()
	if Input.is_action_just_pressed("rotate_boat"):
		direction = !direction
			
	
func boat_selected(boat: Global.Boats) -> void:
	selectedBoat = boat
	
func preview_boat_on_tile(coord: Vector2) -> void:	
#	iterate over grid and resetting to water bg
	for x in Global.GRID_SIZE.x:
		for y in Global.GRID_SIZE.y:
			if !placementGridArray[x][y].hasBoat:
				placementGridArray[x][y].texture_normal = bgWater
				placementGridArray[x][y].texture_focused = oppBg
				placementGridArray[x][y].rotation_degrees = 0
				
	var is_valid_placement = _verify_placement(coord)
	Global.isPlacementValid = is_valid_placement
	
	_preview_sprite(coord, is_valid_placement)
	
	#Global.isPlacingBoat = false
	
func _preview_sprite(coord: Vector2, is_valid_placement) -> void:
	if is_valid_placement:
		_valid_preview(coord)
	
	else:
		_invalid_preview(coord)
		
	
func _replace_sprite(coord: Vector2) -> void:
	placementGridArray[coord.x][coord.y].texture_focused = boatBack
	placementGridArray[coord.x][coord.y].texture_normal = boatBack
	placementGridArray[coord.x][coord.y].hasBoat = true
	placementGridArray[coord.x][coord.y].boat = selectedBoat
	placementGridArray[coord.x][coord.y].boatID = boatID
	placementGridArray[coord.x][coord.y].rotation = 0
	
	
	if direction:
		#placementGridArray[coord.x][coord.y].rotation_degrees = 90
		placementGridArray[coord.x][coord.y].texture_focused = vertical_back
		placementGridArray[coord.x][coord.y].texture_normal = vertical_back
		coord.x += 1
		
#	Code for replacing the sprite if the rotation is true
	#if direction: 
		#placementGridArray[coord.x][coord.y].texture_normal = vertical_back
		#for x in selectedBoat:
			#placementGridArray[coord.x][coord.y].texture_normal = vertical_middle
		#placementGridArray[coord.x][coord.y].texture_normal = vertical_front
		
	else:
		coord.y += 1
	
	for x in selectedBoat:
		placementGridArray[coord.x][coord.y].texture_normal = boatMiddle
		placementGridArray[coord.x][coord.y].hasBoat = true
		placementGridArray[coord.x][coord.y].boat = selectedBoat
		placementGridArray[coord.x][coord.y].boatID = boatID
		placementGridArray[coord.x][coord.y].rotation = 0
		if direction: 
			placementGridArray[coord.x][coord.y].texture_focused = vertical_middle
			placementGridArray[coord.x][coord.y].texture_normal = vertical_middle
			coord.x += 1
		else: 
			coord.y += 1
		
	placementGridArray[coord.x][coord.y].texture_normal = boatFront
	placementGridArray[coord.x][coord.y].hasBoat = true
	placementGridArray[coord.x][coord.y].boat = selectedBoat
	placementGridArray[coord.x][coord.y].boatID = boatID
	placementGridArray[coord.x][coord.y].rotation = 0
	if direction: 
		placementGridArray[coord.x][coord.y].texture_focused = vertical_front
		placementGridArray[coord.x][coord.y].texture_normal = vertical_front
	
	boatID += 1
	
func _verify_placement(coord: Vector2) -> bool:
	for size in (selectedBoat + 2):
		if direction:
			if coord.x + size >= Global.GRID_SIZE.x or coord.y >= Global.GRID_SIZE.y:
				print("error: exceeds grid size")
				return false
			if placementGridArray[coord.x + size][coord.y].hasBoat:
				print("error: overlapping with boat")
				return false
		else:
			if coord.x >= Global.GRID_SIZE.x or coord.y + size >= Global.GRID_SIZE.y:
				print("error: exceeds grid size")
				return false
			if placementGridArray[coord.x][coord.y + size].hasBoat:
				print("error: overlapping with boat")
				return false
	return true


func _on_submarine_btn_pressed() -> void:
	pass # Replace with function body.
	
func _place_boat_at_tile(coord: Vector2) -> void:
	if Global.isPlacingBoat and Global.isPlacementValid:
		_replace_sprite(coord)
		Global.isPlacingBoat = false
		Global.isPlacementValid = false
		amount_boats += 1
		if amount_boats == 5:
			var readyBtn = get_node("VBoxContainer/ReadyBtn/MarginContainer/Button")
			readyBtn.disabled = false
			readyBtn.grab_focus()
			
		
func _valid_preview(coord: Vector2) -> void:
	placementGridArray[coord.x][coord.y].texture_focused = boatBack
	placementGridArray[coord.x][coord.y].texture_normal = boatBack
	
	
	if direction:
		placementGridArray[coord.x][coord.y].rotation_degrees = 90
		coord.x += 1
	else:
		coord.y += 1
	
	for x in selectedBoat:
		placementGridArray[coord.x][coord.y].texture_normal = boatMiddle
		
		
		if direction: 
			placementGridArray[coord.x][coord.y].rotation_degrees = 90
			coord.x += 1
		else: 
			coord.y += 1
		
	placementGridArray[coord.x][coord.y].texture_normal = boatFront
	
	
	if direction: 
		placementGridArray[coord.x][coord.y].rotation_degrees = 90
		
func _invalid_preview(coord: Vector2) -> void:
	
	if !placementGridArray[coord.x][coord.y].hasBoat:
		placementGridArray[coord.x][coord.y].texture_focused = red_boat_back
		placementGridArray[coord.x][coord.y].texture_normal = red_boat_back
		if direction:
			placementGridArray[coord.x][coord.y].rotation_degrees = 90
	
	if direction:
		coord.x += 1
	else:
		coord.y += 1
	
	if coord.x >= Global.GRID_SIZE.x or coord.y >= Global.GRID_SIZE.y:
		return
		
	for x in selectedBoat:
		if !placementGridArray[coord.x][coord.y].hasBoat:
			placementGridArray[coord.x][coord.y].texture_normal = red_boat_middle
			
			if direction: 
				placementGridArray[coord.x][coord.y].rotation_degrees = 90
		
		if direction:
			coord.x += 1
		else:
			coord.y += 1
		
		if coord.x >= Global.GRID_SIZE.x or coord.y >= Global.GRID_SIZE.y:
			return
	
	if coord.x >= Global.GRID_SIZE.x or coord.y >= Global.GRID_SIZE.y:
		return
	
	if !placementGridArray[coord.x][coord.y].hasBoat:		
		placementGridArray[coord.x][coord.y].texture_normal = red_boat_front
	
		if direction: 
			placementGridArray[coord.x][coord.y].rotation_degrees = 90


func _on_button_pressed() -> void:
	#for x in Global.GRID_SIZE.x:
		#for y in Global.GRID_SIZE.y:
			#Global.boardstates[currentBoard][x][y] = {
				#"hasBoat": placementGridArray[x][y].hasBoat
			#}
	Global.boardstates[currentBoard] = placementGridArray.duplicate(true)
	
	if Global.isPlayerOneTurn:
		Global.nextSceneToLoad = "res://scenes/setup_screen.tscn"
	else:
		Global.nextSceneToLoad = "res://scenes/play_screen.tscn"
	
	_init_ships_boards()
	_init_shots_boards()
	Global.isPlayerOneTurn = !Global.isPlayerOneTurn
	
	get_tree().change_scene_to_file("res://scenes/swap_scene.tscn")
	
func _init_shots_boards() -> void:
	var playerShotsBoard = []
	
	playerShotsBoard.resize(Global.GRID_SIZE.x)
	
	for x in Global.GRID_SIZE.x:
		playerShotsBoard[x] = []
		playerShotsBoard[x].resize(Global.GRID_SIZE.y)
		
		for y in Global.GRID_SIZE.y:
			playerShotsBoard[x][y] = ShotsBtn.new()
			playerShotsBoard[x][y].init(Vector2(x,y))
			playerShotsBoard[x][y].texture_normal = oppBg
			
			
	Global.boardstates[currentBoard + 1] = playerShotsBoard.duplicate(true)
	
func _init_ships_boards() -> void:
	var playerShipsBoard = []
	
	playerShipsBoard.resize(Global.GRID_SIZE.x)
	
	for x in Global.GRID_SIZE.x:
		playerShipsBoard[x] = []
		playerShipsBoard[x].resize(Global.GRID_SIZE.y)
		
		for y in Global.GRID_SIZE.y:
			playerShipsBoard[x][y] = ShipsBtn.new()
			playerShipsBoard[x][y].init(Vector2(x,y))
			#playerShipsBoard[x][y].disabled = true
			playerShipsBoard[x][y].hasBoat = placementGridArray[x][y].hasBoat
			if placementGridArray[x][y].hasBoat:
				playerShipsBoard[x][y].boat = placementGridArray[x][y].boat
				playerShipsBoard[x][y].boatID = placementGridArray[x][y].boatID
				playerShipsBoard[x][y].texture_normal = placementGridArray[x][y].texture_normal
			else:
				playerShipsBoard[x][y].texture_normal = placementGridArray[x][y].texture_normal 
				
	Global.boardstates[currentBoard] = playerShipsBoard.duplicate(true)
			
			
			
			
			
