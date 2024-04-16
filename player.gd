extends Area2D

@onready var spaceship = $Spaceship

@export var speed = 500
@export var cust_grav = 250
@export var rotateSpeed = 90

var spaceshipDown = deg_to_rad(120)
var spaceshipUp = deg_to_rad(60)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move"):
		spaceship.animation = "on"
		if spaceship.rotation >= spaceshipUp:
			spaceship.rotation -= deg_to_rad(rotateSpeed) * delta
	else:
		spaceship.animation = "off"
		if spaceship.rotation <= spaceshipDown:
			spaceship.rotation += deg_to_rad(rotateSpeed) * delta

	var pointing = ((rad_to_deg(spaceship.rotation) - 90) / 30)
	spaceship.position += Vector2.DOWN * cust_grav * delta * pointing

func start(pos):
	spaceship.position = pos #75, 324

#poweupstates can be handled here
func _on_body_entered_player(body):
	hide()
	print_debug("FFS")
	$CollisionShape2D.set_deferred("disabled", true)
