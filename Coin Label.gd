extends Label

var coins := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	text = "Coins collected: " + str(coins)
	pass


func _on_player_pluscoin():
	coins = coins + 1
	pass # Replace with function body.


func _on_gamemain_reset_coins():
	coins = 0
	pass # Replace with function body.
