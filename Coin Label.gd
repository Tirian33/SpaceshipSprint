extends Label


func _process(_delta) -> void:
	#text = "Coins collected: " + str(coins)
	text = "Coins collected: " + str(Global.coins)


func _on_player_pluscoin():
	#coins = coins + 1
	Global.coins += 1 * Global.coin_mult


func _on_gamemain_reset_coins():
	Global.coins = 0
