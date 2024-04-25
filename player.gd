extends Area2D

signal death
signal make_gold
signal return_normal
signal go_fast
signal go_rainbow

@onready var spaceship = $Spaceship
@onready var sfx = $thruster
@onready var altSFX = $MiscAudio
@onready var powerUpTimer = $PowerUpTimer
@export var cust_grav = 250
@export var rotateSpeed = 90
@export var powerUpState = ""
@export var powerUpDuration = 15
@export var coins = 0

var spaceshipDown = deg_to_rad(120)
var spaceshipUp = deg_to_rad(60)
var playing_sound = false
var alive = true

signal pluscoin


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not alive:
		return

	if Input.is_action_pressed("move"):
		spaceship.animation = "on"
		if rotation >= spaceshipUp:
			rotation -= deg_to_rad(rotateSpeed) * delta
		
		if not playing_sound:
			sfx.play()
			playing_sound = true
		
	else:
		spaceship.animation = "off"
		if rotation <= spaceshipDown:
			rotation += deg_to_rad(rotateSpeed) * delta
		
		if playing_sound:
			sfx.stop()
			playing_sound = false

	var pointing = ((rad_to_deg(rotation) - 90) / 30)
	position += Vector2.DOWN * cust_grav * delta * pointing
	
	if position.y < -1 or position.y > 649:
		die()


func start():
	print_debug("RESTART")
	coins = 0
	position.x = 75
	position.y = 324 #75, 324
	alive = true


func die():
	alive = false
	sfx.stop()
	altSFX.stop()
	altSFX.stream = preload("res://audio/death.tres")
	altSFX.play()
	send_normal_signals()
	powerUpState = ""
	powerUpTimer.stop()
	cust_grav = 250
	death.emit()
	


func send_normal_signals():
	# Signal existing asteroids to become normal
	get_tree().call_group("asteroids", "become_normal")
	# Signal asteroid generate to generate normal asteroids at normal speed
	return_normal.emit()


func power_shield():
	powerUpState = "shield"
	send_normal_signals()
	altSFX.stream = load("res://audio/Shield.tres")
	altSFX.play()
	powerUpTimer.start(powerUpDuration)

	
func power_midas():
	powerUpState = "midas"
	# Signal existing asteroids to become gold
	get_tree().call_group("asteroids", "become_gold")
	# Signal asteroid generate to generate gold asteroids
	make_gold.emit()
	altSFX.stream = load("res://audio/midas.tres")
	altSFX.play()
	powerUpTimer.start(powerUpDuration)

	
func power_fast():
	powerUpState = "fast"
	go_fast.emit()
	powerUpTimer.start(powerUpDuration)


func power_rgb():
	powerUpState = "rainbow"
	# Signal existing asteroids to become rainbow
	get_tree().call_group("asteroids", "become_rainbow")
	# Signal asteroid generate to generate rainbow asteroids
	go_rainbow.emit()
	altSFX.stream = load("res://audio/RGB.tres")
	altSFX.play()
	powerUpTimer.start(powerUpDuration)

func _on_area_entered_player(area):
	if not is_instance_valid(area):
		return
	
	if area.is_in_group("coins"):
		area.queue_free()
		coins +=1
		# increment play gold by 1
		print("Player has " + str(coins) + " gold!")
		emit_signal("pluscoin")
		
	elif area.is_in_group("powerup"):
		match area.get_meta("effectID"):
			0:
				power_shield()
			1:
				power_midas()
			2:
				power_fast()
			3:
				power_rgb()
			_:
				print_debug("Powerup not recognized")

		area.queue_free()
		print("Activated powerup!")
	elif powerUpState == "shield":
		area.break_apart()
	elif powerUpState == "midas":
		area.become_coin()
		coins += 2
	elif powerUpState == "rainbow":
		area.become_coin()
		coins += 1
	else:
		die()


func _on_power_up_timer_timeout():
	print_debug("normal")

	send_normal_signals()

	powerUpState = ""
