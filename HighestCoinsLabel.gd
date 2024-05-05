extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Three highest coins: \n1. Coins: " + str(Global.conecoins) + " Distance: " + str(Global.conedistance) + " Time: " + str(Global.conetime) + "\n2. Coins: " + str(Global.ctwocoins) + " Distance: " + str(Global.ctwodistance) + " Time: " + str(Global.ctwotime) + "\n3. Coins: " + str(Global.cthreecoins) + " Distance: " + str(Global.cthreedistance) + " Time: " + str(Global.cthreetime) + "\n"
	pass
