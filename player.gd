extends Area2D

signal death
signal make_gold
signal return_normal
signal go_fast
signal go_rainbow

@onready var spaceship = $Spaceship
@onready var sfx = $thruster
@onready var dieSound = $DeathNoise
@onready var powerUpTimer = $PowerUpTimer
@export var cust_grav = 250
@export var rotateSpeed = 90
@export var powerUpState = ""
@export var powerUpDuration = 15

var spaceshipDown = deg_to_rad(120)
var spaceshipUp = deg_to_rad(60)
var playing_sound = false
var alive = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive:
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
	position.x = 75
	position.y = 324 #75, 324
	alive = true


func die():
	alive = false
	sfx.stop()
	dieSound.play()
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


# TODO: Change to separate functions that activate on appropriate power up collision
func _input(event):
	if event.is_action_pressed("shield"):
		print_debug("shield")
		powerUpState = "shield"

		send_normal_signals()

		powerUpTimer.start(powerUpDuration)

	if event.is_action_pressed("midas"):
		print_debug("midas")
		powerUpState = "midas"

		send_normal_signals()

		# Signal existing asteroids to become gold
		get_tree().call_group("asteroids", "become_gold")
		# Signal asteroid generate to generate gold asteroids
		make_gold.emit()

		powerUpTimer.start(powerUpDuration)

	if event.is_action_pressed("fast"):
		print_debug("fast")
		powerUpState = "fast"

		send_normal_signals()
		go_fast.emit()

		powerUpTimer.start(powerUpDuration)

	if event.is_action_pressed("rainbow"):
		print_debug("rainbow")
		powerUpState = "rainbow"

		send_normal_signals()
		# Signal existing asteroids to become rainbow
		get_tree().call_group("asteroids", "become_rainbow")
		# Signal asteroid generate to generate rainbow asteroids
		go_rainbow.emit()

		powerUpTimer.start(powerUpDuration)


func _on_area_entered_player(area):
	if powerUpState == "shield":
		area.break_apart()
	elif powerUpState == "midas":
		area.become_coin()
	elif powerUpState == "rainbow":
		area.become_coin()
	else:
		die()


func _on_power_up_timer_timeout():
	print_debug("normal")

	send_normal_signals()

	powerUpState = ""
