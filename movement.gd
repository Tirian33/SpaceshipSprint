extends Node

var is_game_running: bool
var random = RandomNumberGenerator.new()

# Asteroid Settings
@export var asteroid_scene : PackedScene
var asteroid_type = ""
var screen_size : Vector2
var asteroids : Array
var scroll : int
var scroll_speed : int = 4 #4 = normal; 8 = 2x ...
var scroll_target : int = 4
const ASTEROID_DELAY : int = 100
const ASTEROID_RANGE : int = 300



func _ready():
	screen_size = get_viewport().get_visible_rect().size
	is_game_running = true
	new_game()


func new_game():
	$"BGM-Generic".play()
	$Player.start()
	is_game_running = true
	scroll = 0
	asteroids.clear()
	generate_asteroids()
	$AsteroidTimer.start()



func _process(_delta):
	#print(Engine.get_frames_per_second())

	if is_game_running:
		#scroll += SCROLL_SPEED
		#if scroll >= screen_size.x:
			#scroll = 0

		for asteroid in asteroids:
			if is_instance_valid(asteroid):
				asteroid.position.x -= scroll_speed

		if $"Player/Pause Active Node/Continue Button".visible == false:
			$"Player/Pause Active Node/Menu Button".visible = false


func _on_asteroid_timer_timeout():
	generate_asteroids()


func generate_asteroids():
	random.randomize()
	
	var asteroid : Area2D = asteroid_scene.instantiate()
	asteroid.position.x = screen_size.x + ASTEROID_DELAY
	asteroid.position.y = screen_size.y / 2 + random.randi_range(-ASTEROID_RANGE, ASTEROID_RANGE)
	
	# Change asteroid sprite
	var asteroid_sprite : AnimatedSprite2D = asteroid.get_node("./AnimatedSprite2D")
	asteroid_sprite.frame = random.randi_range(0, 31)

	if asteroid_type == "gold":
		asteroid.become_gold()
	if asteroid_type == "rainbow":
		asteroid.become_rainbow()

	add_child(asteroid)
	asteroids.append(asteroid)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$"Player/Pause Active Node/Continue Button".visible = true 
		$"Player/Pause Active Node/Menu Button".visible = true
		get_tree().set_deferred("paused", true)


func _on_player_death():
	is_game_running = false
	$AsteroidTimer.stop()
	$"BGM-Generic".stop()
	$SpeedRampTimer.stop()
	for asteroid in asteroids:
		if is_instance_valid(asteroid):
			asteroid.queue_free()
	asteroids.clear()
	scroll_speed = 4
	$"LoseScreen".show()
	pass # Replace with function body.


func _on_player_make_gold():
	#print_debug("Making gold asteroids.")
	asteroid_type = "gold"


func _on_player_return_normal():
	#print_debug("Making normal asteroids and slowing down.")
	$AsteroidTimer.wait_time = 0.4
	$background.go_normal()
	asteroid_type = ""
	scroll_target = 4
	$SpeedRampTimer.start()


func _on_player_go_fast():
	#print_debug("Asteroids going fast.")
	scroll_target = 8
	$SpeedRampTimer.start()
	$background.go_fast()


func _on_player_go_rainbow():
	#print_debug("Making rainbow asteroids and stars.")
	asteroid_type = "rainbow"
	scroll_target = 16
	$SpeedRampTimer.start()
	#$AsteroidTimer.wait_time = 0.1
	$background.go_rainbow()


func _on_speed_ramp_timer_timeout():
	print_debug(scroll_speed)
	if scroll_speed < 4:
		scroll_speed = 4
		scroll_target = 4
		$Player.cust_grav = 250
		$SpeedRampTimer.stop()
		
	elif scroll_target > 4:
		scroll_speed = scroll_speed + 1
		$Player.cust_grav += 25
	else:
		scroll_speed = scroll_speed -2
		$Player.cust_grav -= 50
	
	if scroll_target == scroll_speed:
		$SpeedRampTimer.stop()
		print_debug("stopped")
	
