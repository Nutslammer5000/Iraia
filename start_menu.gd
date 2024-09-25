extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void: #This is the play button when you press this button the game starts you at level 1
	get_tree().change_scene_to_file("res://world.tscn")
	pass 


func _on_quit_pressed() -> void: #This is the code for the quit button, when its pressed it closes the game.
	get_tree().quit()
	pass
  
