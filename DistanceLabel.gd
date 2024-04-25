extends Label

var time_elapsed := 0.0
var distance := 0
var time := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	text = "Distance: " + str(distance)
	pass


func _on_distance_timer_timeout():
	time = time + 1
	distance = time * 100
	pass # Replace with function body.



func _on_gamemain_reset_distance():
	time = 0
	pass # Replace with function body.
