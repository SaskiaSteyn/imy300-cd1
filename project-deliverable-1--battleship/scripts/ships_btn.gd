extends TextureButton
class_name ShipsBtn

var gridCoordinates: Vector2
var has_been_shot: bool

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
		

func init(newCoords: Vector2) -> void:
	gridCoordinates = newCoords
	has_been_shot = false
	
func clone(ref: ShipsBtn) -> void:
	gridCoordinates = ref.gridCoordinates
	hasBoat = ref.hasBoat
	boat = ref.boat
	texture_normal = ref.texture_normal
	texture_focused = ref.texture_focused
	boatID = ref.boatID
	has_been_shot = ref.has_been_shot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.ignore_texture_size = true
	self.stretch_mode = TextureButton.STRETCH_SCALE
	self.custom_minimum_size = Vector2(64, 64)
	self.pivot_offset = Vector2(32, 32)
	#self.rotation_degrees = temp_rotation


func set_grid_coords(newCoords: Vector2) -> void:
	gridCoordinates = newCoords
	

func set_rotation_custom(rotation) -> void:
	print("SETTING ROTATION")
	print(self.get_rotation())
	self.rotation = deg_to_rad(rotation)
	print("NEW ROTATION")
	print(self.get_rotation())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _setup_preview_boat_placement() -> void:
	if Global.isPlacingBoat:
		Global.setup_tile_focused_boat.emit(gridCoordinates)

func _place_boat() -> void:
	if Global.isPlacingBoat and Global.isPlacementValid:
		Global.place_boat_at_tile.emit(gridCoordinates)
		
	
