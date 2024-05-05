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

var tonetime : int = 0
var ttwotime : int = 0
var tthreetime : int = 0
var tonedistance : int = 0
var ttwodistance : int = 0
var tthreedistance : int = 0
var tonecoins : int = 0
var ttwocoins : int = 0
var tthreecoins : int = 0



#status: 0 = unpurchased, 1 = purchased, 2 = unequipped, 3 = equipped
func _ready():
	#new_save()               #for testing with save file
	if not read_save():
		new_save()
	else:
		item_list = read_save()
	gold = item_list["Gold"]
	get_skin()
	
	if not FileAccess.file_exists(path2):
		initialize_records()


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
	
	save_records(distance, coins, time)


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
func save_records(distance, coins, time):
	var record = {
		"Distance": distance,
		"Coins": coins,
		"Time": time
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
		
		tonedistance = 0
		ttwodistance = 0
		tthreedistance = 0
		tonecoins = 0
		tonetime = 0
		ttwocoins = 0
		ttwotime = 0
		tthreecoins = 0
		tthreetime = 0
		
		for record in records:
			var distance = record["Distance"]
			var coins = record["Coins"]
			var time = record["Time"]
			if distance > onedistance:
				threedistance = twodistance
				twodistance = onedistance
				onedistance = distance
				threecoins = twocoins
				twocoins = onecoins
				onecoins = coins
				threetime = twotime
				twotime = onetime
				onetime = time
			elif distance > twodistance:
				threedistance = twodistance
				twodistance = distance
				threecoins = twocoins
				twocoins = coins
				threetime = twotime
				twotime = time
			elif distance > threedistance:
				threedistance = distance
				threecoins = coins
				threetime = time

		for record in records:
			var distance = record["Distance"]
			var coins = record["Coins"]
			var time = record["Time"]
			if coins > conecoins:
				cthreecoins = ctwocoins
				ctwocoins = conecoins
				conecoins = coins
				cthreedistance = ctwodistance
				ctwodistance = conedistance
				conedistance = distance
				cthreetime = ctwotime
				ctwotime = conetime
				conetime = time
			elif coins > ctwocoins:
				cthreecoins = ctwocoins
				ctwocoins = coins
				cthreedistance = ctwodistance
				ctwodistance = distance
				cthreetime = ctwotime
				ctwotime = time
			elif coins > cthreecoins:
				cthreecoins = coins
				cthreedistance = distance
				cthreetime = time

		for record in records:
			var distance = record["Distance"]
			var coins = record["Coins"]
			var time = record["Time"]
			if time > tonetime:
				tthreetime = ttwotime
				ttwotime = tonetime
				tonetime = time
				tthreedistance = ttwodistance
				ttwodistance = tonedistance
				tonedistance = distance
				tthreecoins = ttwocoins
				ttwocoins = tonecoins
				tonecoins = coins
			elif time > ttwotime:
				tthreetime = ttwotime
				ttwotime = time
				tthreedistance = ttwodistance
				ttwodistance = distance
				tthreecoins = ttwocoins
				ttwocoins = coins
			elif time > tthreetime:
				tthreetime = time
				tthreedistance = distance
				tthreecoins = coins
	
	file.close()
	return data

func save_data(data):
	var file = FileAccess.open(path2, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func game_completed(distance, coins, time):
	save_records(distance, coins, time)

func _compare_distances(a, b):
	return b["Distance"] - a["Distance"]


