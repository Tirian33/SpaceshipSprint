extends Node

var json = JSON.new()
var path = "user://shop.json"

signal skin_changed
signal gold_update
var gold
var item_list = {}

#status: 0 = unpurchased, 1 = purchased, 2 = unequipped, 3 = equipped
func _ready():
	#new_save()
	if not read_save():
		new_save()
	else:
		item_list = read_save()
	gold = item_list["Gold"]

func write_save(data):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(data))
	file.close()
	file = null

func read_save():
	var file = FileAccess.open(path, FileAccess.READ)
	var data = json.parse_string(file.get_as_text())
	return data

#create new save or overwrite the old save
func new_save():
	var file = FileAccess.open("res://Shop/default_items.json", FileAccess.READ)
	var data = json.parse_string(file.get_as_text())
	item_list = data
	write_save(data)


