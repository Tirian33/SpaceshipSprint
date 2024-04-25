extends Label

@export var coins := 0


func _process(delta) -> void:
	#text = "Coins collected: " + str(coins)
	text = "Coins collected: " + str(Global.gold)


func _on_player_pluscoin():
	#coins = coins + 1
	Global.gold += 1


func _on_gamemain_reset_coins():
	coins = 0
