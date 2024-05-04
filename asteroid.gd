extends Area2D

var random = RandomNumberGenerator.new()


func _process(_delta):
	if position.x < -60:
		# TODO: Ideally score should increment for each asteroid successfully dodged
		queue_free()


func become_gold():
	# TODO: Fix tint or replace texture
	modulate = Color(1, 1, 0)


func become_rainbow():
	random.randomize()
	modulate = Color.from_hsv(random.randf_range(-1.0, 1.0), 1.0, 1.0)


func become_normal():
	modulate = Color(1, 1, 1)
