extends Node

@export var speed = 500
@export var gravity = 250
@export var rotateSpeed = 90

@onready var spaceship = $"CanvasLayer/Spaceship"
@onready var screen_size = DisplayServer.window_get_size()
@onready var backgroundA = $"backgroundA/CanvasLayer"
@onready var backgroundB = $"backgroundB/CanvasLayer"
@onready var backgroundC = $"backgroundC/CanvasLayer"

var spaceshipDown = deg_to_rad(120)
var spaceshipUp = deg_to_rad(60)

func _ready():
	backgroundB.offset.x = screen_size.x
	backgroundC.offset.x = 2 * screen_size.x
	spaceship.play()

func _process(delta):
	if backgroundA.offset.x <= -screen_size.x * 1.5:
		backgroundA.offset.x = backgroundC.offset.x + screen_size.x

	if backgroundB.offset.x <= -screen_size.x * 1.5:
		backgroundB.offset.x = backgroundA.offset.x + screen_size.x

	if backgroundC.offset.x <= -screen_size.x * 1.5:
		backgroundC.offset.x = backgroundB.offset.x + screen_size.x

	var backgroundVelocity = Vector2.LEFT * speed
	backgroundA.offset += backgroundVelocity * delta
	backgroundB.offset += backgroundVelocity * delta
	backgroundC.offset += backgroundVelocity * delta

	if Input.is_action_pressed("move"):
		spaceship.animation = "on"
		if spaceship.rotation >= spaceshipUp:
			spaceship.rotation -= deg_to_rad(rotateSpeed) * delta
	else:
		spaceship.animation = "off"
		if spaceship.rotation <= spaceshipDown:
			spaceship.rotation += deg_to_rad(rotateSpeed) * delta

	var pointing = ((rad_to_deg(spaceship.rotation) - 90) / 30)
	spaceship.position += Vector2.DOWN * gravity * delta * pointing
	print_debug(spaceship.position)


func _on_player_collision(body):
	spaceship.hide()
	pass # Replace with function body.
