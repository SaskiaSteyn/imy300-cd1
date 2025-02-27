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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("focus_entered", _setup_preview_boat_placement)
	Global.boat_placed_on_tile_map.connect(change_state_of_boat.bind())


func set_grid_coords(newCoords: Vector2) -> void:
	gridCoordinates = newCoords

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _setup_preview_boat_placement() -> void:
	if Global.isPlacingBoat:
		Global.setup_tile_focused_boat.emit(gridCoordinates)
		
func change_state_of_boat(boat: Global.Boats) -> void:
	print("test")
	
		
