extends TextureButton
class_name ShotsBtn

var gridCoordinates: Vector2
var shots_fired_at_tile: bool = false

var grey_bg = load("res://assets/opponent-bg-(128x128).png")

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
		
func init(newCoords: Vector2) -> void:
	gridCoordinates = newCoords
	
func clone(ref: ShotsBtn) -> void:
	gridCoordinates = ref.gridCoordinates
	shots_fired_at_tile = ref.shots_fired_at_tile
	hasBoat = ref.hasBoat
	boat = ref.boat
	texture_normal = ref.texture_normal
	texture_focused = ref.texture_focused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.ignore_texture_size = true
	self.stretch_mode = TextureButton.STRETCH_SCALE
	self.custom_minimum_size = Vector2(64, 64)
	self.pivot_offset = Vector2(32, 32)
	self.connect("focus_entered", _target_preview)
	self.connect("mouse_entered", _target_preview)
	self.connect("pressed", _lock_target)
	self.connect("focus_exited", _reset_texture)
	self.connect("mouse_exited", _reset_texture)


func set_grid_coords(newCoords: Vector2) -> void:
	gridCoordinates = newCoords

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _target_preview() -> void:
	if Global.isTargeting and (!shots_fired_at_tile and !disabled):
		Global.target_preview.emit(gridCoordinates)

func _lock_target() -> void:
	if Global.isTargeting and (!shots_fired_at_tile and !disabled):
		Global.target_locked.emit(gridCoordinates)
		
func _reset_texture() -> void:
	if !shots_fired_at_tile and !disabled and Global.isTargeting:
		texture_normal = grey_bg
		texture_focused = grey_bg 
