extends Control

@onready var button = $Panel/VBoxContainer/Button
@onready var warning = $"../../Warning"
@onready var item_key = self.get_name()

#initialize item data
#extract specific item from item_list
@onready var item = Global.item_list[item_key]
@onready var cost = item["Cost"]
@onready var des = item["Description"]
@onready var type = item["Type"]
@onready var status = item["Status"]

var skin1 = "7"

func _ready():
	Global.skin_changed.connect(skin_off)
	Global.status_changed.connect(update_status)
	Global.default_ship.connect(default_skin)
	$Panel/VBoxContainer/ItemName.text = item["Name"]
	$Panel/VBoxContainer/ItemCost.text = "$" + str(cost)
	$Panel/VBoxContainer/ItemImg.texture = ResourceLoader.load(item["Image"])
	
	if type == "Skin":
		$Panel.self_modulate = Color(0.502, 0.78, 0.69)
		button.self_modulate = Color(0.502, 0.78, 0.69)
		
		update_status()


func update_status():
	status = Global.item_list[item_key]["Status"]
	if status == 0:
		button.text = "Purchase"
	if status == 1:
		button.text = "Purchased"
	if status == 2:
		button.text = "Equip"
		button.toggle_mode = true
		button.button_pressed = false
	if status == 3:
		button.text = "Equipped"
		button.toggle_mode = true
		button.button_pressed = true

func save_update():
	Global.item_list[item_key]["Status"] = status
	Global.item_list["Gold"] = Global.gold
	Global.write_save(Global.item_list)

func _on_button_pressed():
	if status == 0 and Global.gold >= cost:
		Global.gold -= cost
		Global.gold_update.emit()
		if type == "Power":
			status = 1
			button.text = "Purchased"
		elif type == "Skin":
			status = 2
			button.text = "Equip"
			button.toggle_mode = true
		
	elif status == 0 and Global.gold < Global.gold:
		warning.text = "Not Enough Gold"
		
	elif status == 1:
		warning.text = "Aready Purchased"
		warning.visible = true
	elif status == 2:
		Global.skin_changed.emit()
		button.text = "Equipped"
		status = 3
	elif status == 3:
		button.text = "Equip"
		status = 2
		Global.default_ship.emit()
	save_update()
	Global.get_skin()

func default_skin():
	if item_key == skin1:
		Global.skin_changed.emit()
		button.text = "Equipped"
		button.button_pressed = true
		status = 3
		print(status)
	else:
		pass

func skin_off():
	if status == 3:
		status = 2
		save_update()
		button.text = "Equip"
		button.button_pressed = false
