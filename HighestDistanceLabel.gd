extends Label


func _process(_delta):
	text = "Three longest distances: \n1. Distance: " + str(Global.onedistance) + " Coins: " + str(Global.onecoins) + "\n2. Distance: " + str(Global.twodistance) + " Coins: " + str(Global.twocoins) + "\n3. Distance: " + str(Global.threedistance) + " Coins: " + str(Global.threecoins) + "\n"
