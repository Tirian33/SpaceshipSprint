extends Area2D

@export var effectID: int = 0

@onready var sprite = $AnimatedSprite2D


func _ready():
	sprite.play()


func set_type(type):
	match type:
		0:
			$"Shield".show()
		1:
			$Midas.show()
		2:
			$"Fast".show()
		3:
			$"Rainbow".show()
		_:
			print_debug("Powerup not recognized")
