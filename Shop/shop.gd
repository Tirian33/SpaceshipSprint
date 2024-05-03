extends CanvasLayer


func _ready():
	Global.gold = Global.item_list["Gold"]
	$Panel/Gold.text = "$ " + str(Global.item_list["Gold"])
	Global.gold_update.connect(gold_update)

func gold_update():
	$Panel/Gold.text = "$ " + str(Global.gold)
	Global.item_list["Gold"] = Global.gold

func _on_close_button_pressed():
	get_node("ShopAnimation").play("TransOut")

#warning auto disappearing
func _on_timer_timeout():
	$Panel/Warning.visible = false
