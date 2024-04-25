extends Node

@export var asteroid_scene : PackedScene
@export var coin_scene : PackedScene
@export var powerup_placeholder : PackedScene

var is_game_running: bool
var random = RandomNumberGenerator.new()
var obstacles : Array

# Obstacle Settings
var asteroid_type = ""
var screen_size : Vector2
var scroll : int
var scroll_normal : int = 4
var scroll_speed : int = scroll_normal
const OBSTACLE_DELAY : int = 100
const OBSTACLE_RANGE : int = 300

var last_asteroid_y = -100
var last_coin_y = -100

signal resetDistance
signal resetCoins
   

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	is_game_running = true
	new_game()


func new_game():
	random.randomize()
	$"BGM-Generic".play()
	$Player.start()
	is_game_running = true
	scroll = 0
	obstacles.clear()
	generate_obstacles()
	$ObstacleTimer.start()
	$PowerupSpawnTimer.start()
	emit_signal("resetCoins")
	
	$SecondTimer.start()


func _process(_delta):
	if not is_game_running:
		return

	Global.distance += scroll_speed
 
	for obstacle in obstacles:
		if is_instance_valid(obstacle):
			obstacle.position.x -= scroll_speed

	if scroll_speed != scroll_normal:
		var tl = $Player/PowerUpTimer.get_time_left()
		var st = 3.0 if asteroid_type == "rainbow" else 1.5

		if (tl > 0.0 and tl < st) and $SpeedRampTimer.is_stopped():
			$ObstacleTimer.wait_time = 0.4
			$SpeedRampTimer.start()

	if $"Player/Pause Active Node/Continue Button".visible == false:
		$"Player/Pause Active Node/Menu Button".visible = false


func _on_asteroid_timer_timeout():
	generate_obstacles()


func generate_obstacles():
	
	var chance : int = random.randi_range(0, 10)
	if chance >= 5:
		generate_asteroid()
	elif chance == 0:
		generate_coin()
	else:
		generate_asteroid()
		generate_coin()


func generate_asteroid():
	var asteroid : Area2D = asteroid_scene.instantiate()
	asteroid.position.x = screen_size.x + OBSTACLE_DELAY
	asteroid.position.y = screen_size.y / 2 + random.randi_range(-OBSTACLE_RANGE, OBSTACLE_RANGE)

	asteroid.rotation = deg_to_rad(random.randi_range(0, 360))

	if asteroid_type == "gold":
		asteroid.become_gold()
	if asteroid_type == "rainbow":
		asteroid.become_rainbow()

	add_child(asteroid)
	obstacles.append(asteroid)
	
	last_asteroid_y = asteroid.position.y


func generate_coin():

	var attemptedY = screen_size.y / 2 + random.randi_range(-OBSTACLE_RANGE, OBSTACLE_RANGE)

	#Only generate the coin if it is not in an obstacle
	if abs(last_asteroid_y - attemptedY) > 60:
		var coin : Area2D = coin_scene.instantiate()
		coin.position.x = screen_size.x + OBSTACLE_DELAY
		coin.position.y = attemptedY
		add_child(coin)
		obstacles.append(coin)
		last_coin_y = coin.position.y


func generate_powerup():
	var powerup : Area2D = powerup_placeholder.instantiate()
	#TODO: Add link to shop unlocks; if powerup not unlocked it doesn't spawn

	print_debug("POWERUP GENERATED")
	var chance : int = random.randi_range(0, 16)
	if chance <= 1:
		powerup.set_meta("effectID", 3)
	elif chance <=6:
		powerup.set_meta("effectID", 0)
	elif chance <=11:
		powerup.set_meta("effectID", 1)
	else:
		powerup.set_meta("effectID", 2)

	powerup.position.x = screen_size.x + OBSTACLE_DELAY

	while true:
		var powerup_range = OBSTACLE_RANGE - 60
		var attemptedY = screen_size.y / 2 + random.randi_range(-powerup_range, powerup_range)
		if abs(last_coin_y - attemptedY) < 60:
			continue
		if abs(last_asteroid_y - attemptedY) < 60:
			continue
		powerup.position.y = attemptedY
		break

	add_child(powerup)
	obstacles.append(powerup)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$"Player/Pause Active Node/Continue Button".visible = true 
		$"Player/Pause Active Node/Menu Button".visible = true
		get_tree().set_deferred("paused", true)


func _on_player_death():
	is_game_running = false

	Global.gold += Global.coins
	# Yes, I know this is a very round-a-bout way of doing this,
	# but Godot will throw a warning due to type nonsense if done simpler.
	Global.gold += int(Global.distance / 1000.0)
	Global.gold += int(Global.time / 10.0)

	$ObstacleTimer.stop()
	$"BGM-Generic".stop()
	$SpeedRampTimer.stop()

	$SecondTimer.stop()
	emit_signal("resetDistance")
	emit_signal("resetCoins")

	for obstacle in obstacles:
		if is_instance_valid(obstacle):
			obstacle.queue_free()
	obstacles.clear()
	scroll_speed = 4
	$"LoseScreen".show()

	Global.item_list["Gold"] = Global.gold
	Global.write_save(Global.item_list)


func _on_player_make_gold():
	asteroid_type = "gold"


func _on_player_return_normal():
	$"BGM-Generic".stream_paused = false
	$"BGM-Generic".pitch_scale = 1
	$ObstacleTimer.wait_time = 0.4
	$background.go_normal()
	asteroid_type = ""
	if scroll_speed != scroll_normal:
		$SpeedRampTimer.start()


func _on_player_go_fast():
	$Player/MiscAudio.playing = false
	$"BGM-Generic".pitch_scale = 1.1 
	$SpeedRampTimer.stop()
	scroll_speed = 8
	$Player.cust_grav = 350
	$background.go_fast()


func _on_player_go_rainbow():
	$SpeedRampTimer.stop()
	$"BGM-Generic".stream_paused = true
	asteroid_type = "rainbow"
	scroll_speed = 16
	$Player.cust_grav = 550
	$ObstacleTimer.wait_time = 0.1
	$background.go_rainbow()


func _on_speed_ramp_timer_timeout():
	if scroll_speed > scroll_normal:
		scroll_speed = scroll_speed - 1
		$Player.cust_grav -= 25

	if scroll_speed == scroll_normal:
		$SpeedRampTimer.stop()
