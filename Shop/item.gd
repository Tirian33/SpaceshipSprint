extends Control

signal update
@onready var button = $Panel/VBoxContainer/Button
@onready var warning = $"../../Warning"
@onready var item_key = self.get_name()

#initialize item data
#status: 0 = unpurchased, 1 = purchased, 2 = unequipped, 3 = equipped 
@onready var item = Global.items[item_key]
@onready var cost = item["Cost"]
@onready var des = item["Description"]

func _ready():
	$Panel/VBoxContainer/ItemName.text = item["Name"]
	$Panel/VBoxContainer/ItemCost.text = "$ " + str(item["Cost"])
	#$Panel/VBoxContainer/ItemImg   image will be added later

func _on_button_pressed():
	if button.text == "Purchased":
		warning.text = "Aready Purchased"
		warning.visible = true
	elif Global.gold >= cost:
		button.text = "Purchased"
		Global.gold -= cost
		Global.gold_update.emit()
		warning.visible = false
	else:
		warning.text = "Not Enough Gold"
