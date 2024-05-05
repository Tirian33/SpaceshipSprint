extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Three highest times: \n1. Time: " + str(Global.tonetime) + " Distance: " + str(Global.tonedistance) + " Coins: " + str(Global.tonecoins) + "\n2. Time: " + str(Global.ttwotime) + " Distance: " + str(Global.ttwodistance) + " Coins: " + str(Global.ttwocoins) + "\n3. Time: " + str(Global.tthreetime) + " Distance: " + str(Global.tthreedistance) + " Coins: " + str(Global.tthreecoins) + "\n"
	pass
