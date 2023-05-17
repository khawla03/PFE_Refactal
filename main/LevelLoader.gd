class_name LevelLoader
extends Node

signal about_to_load()
signal started_loading()
signal level_loaded()
signal return_to_menu()

var level: Level = null

onready var loadingScreen = $LoadingScreen


func start_level(path):
	Vars.in_game = true
	emit_signal("about_to_load")
	if ResourceLoader.exists(path) :
		loadingScreen.show()
		yield(loadingScreen, "shown")
		emit_signal("started_loading")
		level = ResourceLoader.load(path).instance()
		if level:
			if level is Level:
				add_child(level)
				loadingScreen.hide()
				emit_signal("level_loaded")
				return
			else:
				print("The selected resource is not a level scene.")
		else:
			print("Error loading the level resource")
	loadingScreen.hide()
	emit_signal("return_to_menu")

func free_level():
	Vars.in_game = false
	loadingScreen.show()
	yield(loadingScreen, "shown")
	level.free()
	emit_signal("return_to_menu")
	loadingScreen.hide()


func restart_level():
	Vars.in_game = true
	loadingScreen.show()
	yield(loadingScreen, "shown")
	var path = level.level_info.path
	level.free()
	if ResourceLoader.exists(path):
		level = ResourceLoader.load(path).instance()
		if level:
			if level is Level:
				add_child(level)
				loadingScreen.hide()
				return
	loadingScreen.hide()
	emit_signal("return_to_menu")


func next_level(path):
	Vars.in_game = true
	loadingScreen.show()
	yield(loadingScreen, "shown")
	if level:
		level.free()
	if ResourceLoader.exists(path):
		level = ResourceLoader.load(path).instance()
		if level:
			if level is Level:
				add_child(level)
				loadingScreen.hide()
				return
	loadingScreen.hide()
	emit_signal("return_to_menu")


func _on_LevelDetailPanel_level_launched(path):
	start_level(path)


func _on_MainPanel_continue_game():
	start_level(Vars.get_var("next_level"))
