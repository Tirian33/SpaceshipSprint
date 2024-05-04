extends Node

var path = "user://shop.json"

signal skin_changed
signal gold_update
signal status_changed
signal default_ship
var gold : int = 0
var coins : int = 0
var distance : int = 0
var time : int = 0
var firstTime : int = 0
var item_list = {}
var skin = 7
var life = 1

#status: 0 = unpurchased, 1 = purchased, 2 = unequipped, 3 = equipped
func _ready():
	#new_save()               #for testing with save file
	if not read_save():
		new_save()
	else:
		item_list = read_save()
	gold = item_list["Gold"]
	get_skin()


#checking if a specific item is enabled
#need a loop to check all item when using
func is_item_enable(id_num):
	var id = str(id_num)
	if item_list[id]["Type"] == "Power":
		if item_list[id]["Status"] == 1:
			return true
	elif item_list[id]["Type"] == "Skin":
		if item_list[id]["Status"] == 3:
			return true
	return false

func get_skin():
	for id in range(7,14):
		if Global.is_item_enable(id):
			skin = id


func write_save(data):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	file = null


func read_save():
	if not FileAccess.file_exists(path):
		write_save({})
	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file = null
	return data


#create new save or overwrite the old save
func new_save():
	var file = FileAccess.open("res://Shop/default_items.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	item_list = data
	write_save(data)


