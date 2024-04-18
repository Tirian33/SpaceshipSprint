extends Area2D


func _process(_delta):
	if position.x < -60:
		# TODO: Ideally score should increment for each asteroid successfully dodged
		queue_free()


func break_apart():
	# TODO: Start some cool explosion or something
	print_debug("Asteroid die.")
	queue_free()


func become_coin():
	# TODO: Start some cool coin collection animation or something
	print_debug("Asteroid coin.")
	# TODO: Score should increment same as coin
	queue_free()


func become_gold():
	# TODO: Fix tint or replace texture
	modulate = Color(1, 1, 0)


func become_normal():
	modulate = Color(1, 1, 1)
