extends Node

func _ready():
	pass

func new_game():
	$Player.start()
	pass

func _on_HUD_start_game():
	new_game()
	pass