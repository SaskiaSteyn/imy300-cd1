extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play
	var start_button = get_node("Control/Panel/GridContainer/MarginContainer/VBoxContainer/MarginContainer/play")
	start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.clicking_btn_sound()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/setup_screen.tscn")


func _on_exitgame_pressed() -> void:
	get_tree().quit()
