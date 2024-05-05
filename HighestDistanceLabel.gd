extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Three longest distances: \n1. Distance: " + str(Global.onedistance) + " Coins: " + str(Global.onecoins) + " Time: " + str(Global.onetime) + "\n2. Distance: " + str(Global.twodistance) + " Coins: " + str(Global.twocoins) + " Time: " + str(Global.twotime) + "\n3. Distance: " + str(Global.threedistance) + " Coins: " + str(Global.threecoins) + " Time: " + str(Global.threetime) + "\n"
