extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ready_button = get_node("Control/Panel/GridContainer/MarginContainer/Button")
	ready_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.clicking_btn_sound()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(Global.nextSceneToLoad)
