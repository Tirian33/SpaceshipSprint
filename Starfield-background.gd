extends Node

@onready var regular_stars = preload("res://regular-stars.tres")
@onready var fast_stars = preload("res://fast-stars.tres")
@onready var invisible_regular_stars = preload("res://invisible-regular-stars.tres")


func go_normal():
	$GPUParticles2D.process_material = regular_stars
	# We can't change the amount without resetting, so instead we change to a material
	# that doesn't make visible particles.
	$GPUParticles2DMany.process_material = invisible_regular_stars


func go_fast():
	$GPUParticles2D.process_material = fast_stars
	# We can't change the amount without resetting, so instead we enable an extra layer.
	$GPUParticles2DMany.process_material = fast_stars
