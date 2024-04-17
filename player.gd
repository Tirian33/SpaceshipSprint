extends Area2D

signal death

@onready var spaceship = $Spaceship
@onready var sfx = $thruster
@export var cust_grav = 250
@export var rotateSpeed = 90

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
			#print_debug("death")
			die()

func start():
	print_debug("RESTART")
	position.x = 75
	position.y = 324 #75, 324
	alive = true

func die():
	alive = false
	emit_signal("death")

#poweupstates can be handled here
func _on_area_entered_player(area):
	#hide()
	print_debug(area.name)
	die()
	#$CollisionShape2D.set_deferred("disabled", true)
