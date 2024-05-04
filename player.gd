extends Area2D

signal death
signal make_gold
signal return_normal
signal go_fast
signal go_rainbow
signal drop_heart

var ship_path = "./Spaceship" + str(Global.skin - 6)
@onready var spaceship = get_node(ship_path)
@onready var sfx = $thruster
@onready var altSFX = $MiscAudio
@onready var powerUpTimer = $PowerUpTimer
@export var cust_grav = 250
@export var rotateSpeed = 90
@export var powerUpState = ""
@export var powerUpDuration = 15

var spaceshipDown = deg_to_rad(120)
var spaceshipUp = deg_to_rad(60)
var playing_sound = false
var alive = true
var ship_scale = Vector2(0.5,0.5)
var life = 1
signal pluscoin


# Called when the node enters the scene tree for the first time.
func _ready():
	power_smaller_ship()


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
		die(true)


func start():
	print_debug("RESTART")
	position.x = 75
	position.y = 324 #75, 324
	alive = true
	
	spaceship.visible = true
	power_second_chance()


func die(insta_kill):
	if life == 1 or insta_kill:
		spaceship.visible = false
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
	elif life == 2:
		drop_heart.emit()
		life -= 1
		$SFX.stream = preload("res://audio/second-chance-activate.tres")
		$SFX.play()


func send_normal_signals():
	$Shield.visible = false
	# Signal existing asteroids to become normal
	get_tree().call_group("asteroids", "become_normal")
	# Signal asteroid generate to generate normal asteroids at normal speed
	return_normal.emit()


func power_shield():
	powerUpState = "shield"
	send_normal_signals()
	$Shield.visible = true
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


func power_smaller_ship():
	if Global.item_list["4"]["Status"] == 1:
		spaceship.scale *= ship_scale
		$CollisionShape2D.scale *= ship_scale


func power_second_chance():
	if Global.item_list["6"]["Status"] == 1:
		life = 2
	else:
		life = 1


func play_coin_sfx(area):
	area.visible = false
	area.SFX.stream = preload("res://audio/coin.tres")
	area.SFX.play()


func play_explosion_sfx(area):
	area.visible = false
	area.SFX.stream = preload("res://audio/explosion.tres")
	area.SFX.play()


func _on_area_entered_player(area):
	if not is_instance_valid(area):
		return
	
	if area.is_in_group("coins"):
		play_coin_sfx(area)
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
		play_explosion_sfx(area)
	elif powerUpState == "midas":
		play_coin_sfx(area)
		emit_signal("pluscoin")
		emit_signal("pluscoin")
	elif powerUpState == "rainbow":
		play_coin_sfx(area)
		emit_signal("pluscoin")
	else:
		die(false)


func _on_power_up_timer_timeout():
	print_debug("normal")

	send_normal_signals()

	powerUpState = ""
