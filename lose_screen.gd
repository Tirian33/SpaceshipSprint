extends Sprite2D

signal new_run


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_again_button_pressed():
	hide()
	emit_signal("new_run")
	pass # Replace with function body.
