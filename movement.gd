extends Node

var is_game_running: bool
var random = RandomNumberGenerator.new()

# Asteroid Settings
@export var asteroid_scene : PackedScene
var asteroid_type = ""
var screen_size : Vector2
var asteroids : Array
var scroll : int
var scroll_normal : int = 4
var scroll_speed : int = scroll_normal
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
	if not is_game_running:
		return

	for asteroid in asteroids:
		if is_instance_valid(asteroid):
			asteroid.position.x -= scroll_speed

	if scroll_speed != scroll_normal:
		var tl = $Player/PowerUpTimer.get_time_left()
		var st = 3.0 if asteroid_type == "rainbow" else 1.5

		if (tl > 0.0 and tl < st) and $SpeedRampTimer.is_stopped():
			$AsteroidTimer.wait_time = 0.4
			$SpeedRampTimer.start()

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
	asteroid_type = "gold"


func _on_player_return_normal():
	$AsteroidTimer.wait_time = 0.4
	$background.go_normal()
	asteroid_type = ""
	if scroll_speed != scroll_normal:
		$SpeedRampTimer.start()


func _on_player_go_fast():
	$SpeedRampTimer.stop()
	scroll_speed = 8
	$Player.cust_grav = 350
	$background.go_fast()


func _on_player_go_rainbow():
	$SpeedRampTimer.stop()
	asteroid_type = "rainbow"
	scroll_speed = 16
	$Player.cust_grav = 550
	$AsteroidTimer.wait_time = 0.1
	$background.go_rainbow()


func _on_speed_ramp_timer_timeout():
	if scroll_speed > scroll_normal:
		scroll_speed = scroll_speed - 1
		$Player.cust_grav -= 25

	if scroll_speed == scroll_normal:
		$SpeedRampTimer.stop()
