extends Button


func _on_pressed():
	get_tree().set_deferred("paused", false)
	get_tree().change_scene_to_file("res://menu.tscn")
