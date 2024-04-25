extends Area2D

@export var effectID: int = 0

@onready var sprite = $AnimatedSprite2D


func _ready():
	sprite.play()
