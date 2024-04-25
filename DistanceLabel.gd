extends Label


func _process(_delta) -> void:
	text = "Distance: " + str(Global.distance)


func _on_second_timer_timeout():
	Global.time += 1


func _on_gamemain_reset_distance():
	Global.time = 0
	Global.distance = 0
