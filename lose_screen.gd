extends Sprite2D

signal new_run

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_again_button_pressed():
	hide()
	emit_signal("new_run")
	pass # Replace with function body.
