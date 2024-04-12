extends CanvasLayer


func _ready():
	get_node("ShopAnimation").play("TransIn")
	$Panel/Gold.text = "$ " + str(Global.gold)
	
func _on_close_button_pressed():
	get_node("ShopAnimation").play("TransOut")
