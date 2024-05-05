extends Node

var path = "user://shop.json"
var path2 = "user://records.json"

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

var onedistance : int = 0
var twodistance : int = 0
var threedistance : int = 0
var onecoins : int = 0
var onetime : int = 0
var twocoins : int = 0
var twotime : int = 0
var threecoins : int = 0
var threetime : int = 0

var conecoins : int = 0
var ctwocoins : int = 0
var cthreecoins : int = 0
var conedistance : int = 0
var ctwodistance : int = 0
var cthreedistance : int = 0
var conetime : int = 0
var ctwotime : int = 0
var cthreetime : int = 0


#status: 0 = unpurchased, 1 = purchased, 2 = unequipped, 3 = equipped, 4 = activated
func _ready():
	if not FileAccess.file_exists(path2):
		initialize_records()
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


# Function to initialize the records file if it doesn't exist
func initialize_records():
	var initial_data = {
		"records": []
	}

	save_data(initial_data)


# Function to save game records
func save_records(record_distance, record_coins, record_time):
	var record = {
		"Distance": record_distance,
		"Coins": record_coins,
		"Time": record_time
	}
	var records = load_data()["records"]
	records.append(record)
	var data_to_save = {
		"records": records
	}
	save_data(data_to_save)
	calculate_records()


func load_data():
	var file = FileAccess.open(path2, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data


func calculate_records():
	var file = FileAccess.open(path2, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	var records = data["records"]
	if records.size() > 0:
		records.sort_custom(_compare_distances)
		
		onedistance = 0
		twodistance = 0
		threedistance = 0
		onecoins = 0
		onetime = 0
		twocoins = 0
		twotime = 0
		threecoins = 0
		threetime = 0
		
		conedistance = 0
		ctwodistance = 0
		cthreedistance = 0
		conecoins = 0
		conetime = 0
		ctwocoins = 0
		ctwotime = 0
		cthreecoins = 0
		cthreetime = 0
		
		for record in records:
			var record_distance = record["Distance"]
			var record_coins = record["Coins"]
			var record_time = record["Time"]
			if record_distance > onedistance:
				threedistance = twodistance
				twodistance = onedistance
				onedistance = record_distance
				threecoins = twocoins
				twocoins = onecoins
				onecoins = record_coins
				threetime = twotime
				twotime = onetime
				onetime = record_time
			elif record_distance > twodistance:
				threedistance = twodistance
				twodistance = record_distance
				threecoins = twocoins
				twocoins = record_coins
				threetime = twotime
				twotime = record_time
			elif record_distance > threedistance:
				threedistance = record_distance
				threecoins = record_coins
				threetime = record_time

		for record in records:
			var record_distance = record["Distance"]
			var record_coins = record["Coins"]
			var record_time = record["Time"]
			if record_coins > conecoins:
				cthreecoins = ctwocoins
				ctwocoins = conecoins
				conecoins = record_coins
				cthreedistance = ctwodistance
				ctwodistance = conedistance
				conedistance = record_distance
				cthreetime = ctwotime
				ctwotime = conetime
				conetime = record_time
			elif record_coins > ctwocoins:
				cthreecoins = ctwocoins
				ctwocoins = record_coins
				cthreedistance = ctwodistance
				ctwodistance = record_distance
				cthreetime = ctwotime
				ctwotime = record_time
			elif record_coins > cthreecoins:
				cthreecoins = record_coins
				cthreedistance = record_distance
				cthreetime = record_time

	file.close()


func save_data(data):
	var file = FileAccess.open(path2, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func game_completed(record_distance, record_coins, record_time):
	save_records(record_distance, record_coins, record_time)


func _compare_distances(a, b):
	return b["Distance"] - a["Distance"]
