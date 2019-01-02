extends CanvasLayer
signal start_game

const settings_file = "user://settings.cfg"
const input_actions = ["jump", "duck", "run_left", "run_right", "attack"]
const default_inputs = ["ui_up", "ui_down", "ui_left", "ui_right", "Space"]
var width = 1000
var height = 800
var fullscreen = false

func _ready():
	var config = ConfigFile.new()
	var err = config.load("settings_file")
	var action_name
	var scancode
	var event

	if err:
		config.set_value("display", "width", width)
		config.set_value("display", "height", height)
		config.set_value("display", "fullscreen", fullscreen)
		var i = 0
		for action in input_actions:
			action_name = str(i) + "_" + action
			config.set_value("input", action_name, default_inputs[i])
			i += 1
		config.save(settings_file)
	else:
		set_from_config(config, "display", "width")
		set_from_config(config, "display", "height")
		set_from_config(config, "display", "fullscreen")
		for action in config.get_section_keys("input"):
			scancode = OS.find_scancode_from_string(config.get_value("input", action))
			event = InputEvent()
			event.type = InputEvent.KEY
			event.scancode = scancode
			for old_event in InputMap.get_action_list(action):
				if old_event.type == InputEvent.KEY:
					InputMap.action_erase_event(action, old_event)
			InputMap.action_add_event(action, event)
	pass

func set_from_config(config, section, key):
	if config.has_section.key(section, key):
		set(key, config.get_value(section, key))
	else:
		save_to_config(section, key, get(key))
	pass

func save_to_config(section, key, value):
	var config = ConfigFile.new()
	var err = config.load(settings_file)
	if err:
		print("Configuration file cannot be loaded.")
	else:
		config.set_value(section, key, value)
		config.save(settings_file)
	pass

func save_screen_size():
	var screen_size = OS.get_window_size()
	width = int(screen_size.x)
	height = int(screen_size.y)
	save_to_config("display", "width", width)
	save_to_config("display", "height", height)
	pass

func _on_Start_pressed():
	$Start.hide()
	$Jump.hide()
	$Kneel.hide()
	$Left.hide()
	$Right.hide()
	$Attack.hide()
	emit_signal("start_game")
	pass