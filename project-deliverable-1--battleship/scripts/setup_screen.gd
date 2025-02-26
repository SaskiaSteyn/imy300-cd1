extends Control

var placementGridArray = []
var currentBoard
var selectedBoat: Global.Boats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Connect listeners to button press events
	Global.setup_boat_selected.connect(boat_selected.bind())
	Global.setup_tile_focused_boat.connect(preview_boat_on_tile.bind())
	
#	Determine if it is player One's turn and then set currentBoard
#	to appropriate boardstate
	if(Global.isPlayerOneTurn):
		currentBoard = 0
	else:
		currentBoard = 2
		
#	Creating a new gridcontainer instance for all the battle grid
	var gridContainer = get_node("VBoxContainer/PlayerBoardContainer/MarginContainer/HBoxContainer/GridContainer")
	
	
	var bgWater = load("res://assets/bg-water-(128x128).png")
	var oppBg = load("res://assets/opponent-bg-(128x128).png")
	
	var btnScript = load("res://scripts/setup_grid_btn.gd")
		
	placementGridArray.resize(10)
	for x in Global.GRID_SIZE.x:
		placementGridArray[x] = []
		placementGridArray[x].resize(10)
		for y in Global.GRID_SIZE.y:
			var newGridBtn = GridBtn.new()
			newGridBtn.texture_normal = bgWater
			newGridBtn.texture_focused = oppBg
			newGridBtn.ignore_texture_size = true
			newGridBtn.stretch_mode = TextureButton.STRETCH_SCALE
			newGridBtn.custom_minimum_size = Vector2(64, 64)
			#newGridBtn.set_script(btnScript)
			newGridBtn.set_grid_coords(Vector2(x,y))
			newGridBtn.hasBoat = false
			gridContainer.add_child(newGridBtn)
			placementGridArray[x][y] = newGridBtn
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func boat_selected(boat: Global.Boats) -> void:
	selectedBoat = boat
	
func preview_boat_on_tile(coord: Vector2) -> void:
	print("TILE at %s, %s" % [coord.x, coord.y])
	var boatBack = load("res://assets/boat-back-(128x128).png")
	var boatMiddle = load("res://assets/boat-middle-(128x128).png")
	var boatFront = load("res://assets/boat-front-(128x128).png")
	var bgWater = load("res://assets/bg-water-(128x128).png")
	
#	iterate over grid and resetting to water bg
	for x in Global.GRID_SIZE.x:
		for y in Global.GRID_SIZE.y:
			
			placementGridArray[x][y].texture_normal = bgWater
	
	placementGridArray[coord.x][coord.y].texture_focused = boatBack
	var trackingCoord = coord.y + 1
	
	for x in selectedBoat:
		placementGridArray[coord.x][trackingCoord].texture_normal = boatMiddle
		trackingCoord+=1
	placementGridArray[coord.x][trackingCoord].texture_normal = boatFront
	


func _on_submarine_btn_pressed() -> void:
	pass # Replace with function body.
