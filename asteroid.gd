extends Area2D

@onready var SFX = $SFX

var random = RandomNumberGenerator.new()
var die_x = -60


func _process(_delta):
	if position.x < die_x:
		queue_free()


func become_gold():
	modulate = Color(1, 1, 0)


func become_rainbow():
	# Give SFX adequate time to finish before queue-freeing
	die_x = -1000
	random.randomize()
	modulate = Color.from_hsv(random.randf_range(-1.0, 1.0), 1.0, 1.0)


func become_normal():
	die_x = -60
	modulate = Color(1, 1, 1)
