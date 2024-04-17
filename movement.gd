extends Node

var is_game_running: bool
var random = RandomNumberGenerator.new()

# Asteroid Settings
@export var asteroid_scene : PackedScene
var screen_size : Vector2
var asteroids : Array
var scroll : int
const ASTEROID_DELAY : int = 100
const ASTEROID_RANGE : int = 300
const SCROLL_SPEED : int = 4


func _ready():
	screen_size = get_viewport().get_visible_rect().size
	is_game_running = true
	new_game()
	$AsteroidTimer.start()


func new_game():
	$"BGM-Generic".play()
	$Player.start()
	is_game_running = true
	scroll = 0
	asteroids.clear()
	generate_asteroids()


func _process(delta):
	#print(Engine.get_frames_per_second())
	
	if is_game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		
		for asteroid in asteroids:
			asteroid.position.x -= SCROLL_SPEED
		
		
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
	
	# function to handle spaceship asteroid collision goes here
	#asteroid.hit.connect(player_hit)
	
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
	for obj in asteroids:
		obj.queue_free()
	$"LoseScreen".show()
	pass # Replace with function body.
