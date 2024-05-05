extends Label


func _process(_delta) -> void:
	text = "Coins collected: " + str(Global.coins)


func _on_player_pluscoin():
	Global.coins += 1


func _on_gamemain_reset_coins():
	Global.coins = 0


func _on_player_doublecoin():
	Global.coins *= 2
	
