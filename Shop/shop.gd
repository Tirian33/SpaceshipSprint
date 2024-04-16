extends CanvasLayer


func _ready():
	get_node("ShopAnimation").play("TransIn")
	$Panel/Gold.text = "$ " + str(Global.gold)
	Global.gold_update.connect(gold_update,0)

func gold_update():
	$Panel/Gold.text = "$ " + str(Global.gold)
	

func _on_close_button_pressed():
	get_node("ShopAnimation").play("TransOut")

#warning auto disappearing
func _on_timer_timeout():
	$Panel/Warning.visible = false
