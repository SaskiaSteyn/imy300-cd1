extends Node2D
@onready var congrats_bro = preload("res://assets/sounds/congratulations-male-spoken-264675.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var winner_text = get_node("Control/Panel/VBoxContainer/winner")
	if Global.isPlayerOneTurn:
		winner_text.text = "Player 1 wins!"
	else:
		winner_text.text = "Player 2 wins!"
	
	var last_btn = get_node("Control/Panel/VBoxContainer/MarginContainer/Button")
	last_btn.grab_focus()
	
	AudioPlayer.playOnce(congrats_bro)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Global.clicking_btn_sound()
	pass
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/intro_screen.tscn")
