extends Button


func _on_pressed():
	self.visible = false
	get_tree().set_deferred("paused", false)
