extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	Global.isPlacingBoat = true
	Global.setup_boat_selected.emit(Global.Boats.DESTROYER)
	self.disabled = true
