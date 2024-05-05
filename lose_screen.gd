extends Sprite2D

signal new_run

var img = 0

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_again_button_pressed():
	hide()
	emit_signal("new_run")
	pass # Replace with function body.

func death(death_type):
	if death_type == 0:
		$LoseLabel.show()
		$Wormhole.hide()
		if img != 0:
			texture = load("res://images/LoseScreen.jpg")
			img = 0
	else:
		$LoseLabel.hide()
		$Wormhole.show()
		if img != 1:
			texture = load("res://images/altGameEnd.png")
			img = 1
