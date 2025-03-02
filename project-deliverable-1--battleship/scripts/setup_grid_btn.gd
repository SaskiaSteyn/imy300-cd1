extends TextureButton
class_name GridBtn

var gridCoordinates: Vector2

var hasBoat: bool:
	get:
		return hasBoat
	set(value):
		hasBoat = value

var boat: Global.Boats:
	get:
		return boat
	set(value):
		boat = value

var boatID: int:
	get:
		return boatID
	set(value):
		boatID = value
		
var bgWater = load("res://assets/bg-water-(128x128).png")
var oppBg = load("res://assets/opponent-bg-(128x128).png")

func init(newCoords: Vector2) -> void:
	gridCoordinates = newCoords

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.texture_normal = bgWater
	self.texture_focused = oppBg
	self.ignore_texture_size = true
	self.stretch_mode = TextureButton.STRETCH_SCALE
	self.custom_minimum_size = Vector2(64, 64)
	#self.set_script(btnScript)
	#self.set_grid_coords(Vector2(x,y))
	self.hasBoat = false
	self.pivot_offset = Vector2(32, 32)
	
	self.connect("focus_entered", _setup_preview_boat_placement)
	self.connect("mouse_entered", _setup_preview_boat_placement)
	self.connect("pressed", _place_boat)


func set_grid_coords(newCoords: Vector2) -> void:
	gridCoordinates = newCoords

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _setup_preview_boat_placement() -> void:
	if Global.isPlacingBoat:
		Global.setup_tile_focused_boat.emit(gridCoordinates)

func _place_boat() -> void:
	if Global.isPlacingBoat and Global.isPlacementValid:
		Global.place_boat_at_tile.emit(gridCoordinates)
		
	
