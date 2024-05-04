extends Node2D

var game_scene = preload("res://game_main.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	Global.firstTime = Global.firstTime + 1
	get_tree().change_scene_to_file("res://game_main.tscn")
	
