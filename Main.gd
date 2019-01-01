extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func new_game():
	$Player.start()
	pass

func _on_HUD_start_game():
	new_game()
	pass # replace with function body
