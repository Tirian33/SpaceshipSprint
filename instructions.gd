extends Node2D

var game_scene = preload("res://game_main.tscn")


func _on_start_button_pressed():
	Global.firstTime = Global.firstTime + 1
	get_tree().change_scene_to_file("res://game_main.tscn")
