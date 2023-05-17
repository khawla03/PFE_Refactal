extends CanvasLayer


signal settings_changed()
signal reset_progress()

const SAVE_PATH = "user://settings.tres"

var config : Config

onready var root = $Background


func _ready():
	hide()
	load_settings()


func show():
	root.show()


func hide():
	root.hide()


func save_settings():
	ResourceSaver.save(SAVE_PATH, config)
	emit_signal("settings_changed")


func save_property(property, value):
	config.set(property, value)
	save_settings()


func load_settings():
	var _config = load(SAVE_PATH)
	if _config:
		config = _config
	else:
		config = Config.new()
		save_settings()
	# Init properties
	for p in get_tree().get_nodes_in_group("SettingsProperty"):
		p.init()


func _on_Apply_button_up():
	hide()


func set_fullscreen(enabled):
	OS.window_fullscreen = enabled


func set_vsync(enabled):
	OS.set_use_vsync(enabled)


func reset_progress():
	Progress.reset_progress()
	Vars.clear_vars()
	emit_signal("reset_progress")

func _on_ResetButton_button_up():
	Dialog.show_confirm_dialog(
		"Are you sure you want to reset the game progress? All player data will be removed.",
		funcref(self, "reset_progress"),
		self,
		true
	)
