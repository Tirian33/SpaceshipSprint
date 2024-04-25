extends Label

var distance := 0
var time := 0


func _process(_delta) -> void:
	text = "Distance: " + str(distance)


func _on_distance_timer_timeout():
	time = time + 1


func _on_gamemain_reset_distance():
	time = 0
	distance = 0
