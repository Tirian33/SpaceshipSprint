extends Area2D

@export var effectID: int = 0

@onready var sprite = $AnimatedSprite2D


func _ready():
	sprite.play()


func set_type(type):
	match type:
		0:
			$"Shield-bot".show()
			$"Shield-top".show()
		1:
			$Midas.show()
		2:
			$"2x".show()
		3:
			$RGB.show()
		_:
			print_debug("Powerup not recognized")
