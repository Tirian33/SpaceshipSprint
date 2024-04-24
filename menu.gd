extends Node2D

var game_scene = preload("res://game_main.tscn")


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game_main.tscn")


func _on_shop_button_pressed():
	$Shop.get_node("ShopAnimation").play("RESET")
	$Shop.get_node("ShopAnimation").play("TransIn")


func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
