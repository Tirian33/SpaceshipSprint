extends Label


func _process(_delta):
	text = "Three highest coins: \n1. Coins: " + str(Global.conecoins) + " Distance: " + str(Global.conedistance) +  "\n2. Coins: " + str(Global.ctwocoins) + " Distance: " + str(Global.ctwodistance) + "\n3. Coins: " + str(Global.cthreecoins) + " Distance: " + str(Global.cthreedistance) + "\n"
