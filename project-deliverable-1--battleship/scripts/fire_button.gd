extends Button

var firstPress: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if firstPress:
		var fire_sound = load("res://assets/sounds/cannon-fire-161072 (1).mp3")
		AudioPlayer.playOnce(fire_sound)
		disabled = true
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.start()
		timer.connect("timeout", _on_timer_timeout)
		firstPress = false
	else:
		Global.nextSceneToLoad = "res://scenes/play_screen.tscn"
		Global.isPlayerOneTurn = !Global.isPlayerOneTurn
		get_tree().change_scene_to_file("res://scenes/swap_scene.tscn")
		

func _on_timer_timeout() -> void:
	text = "End turn"
	disabled = false
	
	
