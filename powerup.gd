extends Area2D

@export var effectID: int = 0

@onready var sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
