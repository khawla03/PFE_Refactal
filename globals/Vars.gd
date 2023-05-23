extends Node


const SAVE_PATH = "user://vars.res"
const FILE_PASS = "REFACTALdemo092022"
const GAME_VERSION = "2.0.0"
const GAME_VERSION_NUMBER = 2

var vars = {}
var in_game = false
var show_submit_screen = false


func _ready():
	_load()


func store(key, value):
	vars[key] = value
	_save()


func get_var(key):
	return vars.get(key)


func clear_vars():
	vars.clear()
	_save()


func _load():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		file.open_encrypted_with_pass(SAVE_PATH, File.READ, FILE_PASS)
		vars = str2var(file.get_as_text())
		file.close()


func _save():
	var file = File.new()
	file.open_encrypted_with_pass(SAVE_PATH, File.WRITE, FILE_PASS)
	file.store_string(var2str(vars))
	file.close()
