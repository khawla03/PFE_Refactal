extends Node


#const SAVE_INTERVAL = 10
const FILE_PATH = 'user://actionsdata.json'

var actions: Array = []
var player_data : Dictionary = {
	'data':[]
}
var dirty: bool = false
#var timer: Timer = Timer.new()

func _ready():
	SilentWolf.configure({
			  "api_key": "VynnJnNMZi1S2Ko1xqKpU14Waex7PNei2uBhorzF",
			  "game_id": "Refactal1",
			  "game_version": Vars.GAME_VERSION,
			  "log_level": 0
			})
	load_data()
	pass

func save_action(action_type: String, action_data=''):
	var action : Dictionary = {
		'action': action_type,
		'info': action_data,
		'time':ActionsData.get_time(),
	};
	player_data = {'data':[action]}
	#Vars.store("player_name", player_name)
	actions.append(action)
	dirty = true
	save()
	SilentWolf.Players.post_player_data(Vars.get_var("player_name"), player_data, false)
	

func save():
	# if we haven't logged any new actions, don't save data
	if not dirty:
		return
	var file = File.new()
	file.open(FILE_PATH, File.WRITE)
	file.store_string(to_json(actions))
	file.close()
	dirty = false

func load_data():
	var file = File.new()
	if file.file_exists(FILE_PATH):
		file.open(FILE_PATH, File.READ)
		actions = parse_json(file.get_as_text())
		file.close()

func get_time()->String:
	var time = OS.get_datetime()
	var time_return = String(time.day)+"/"+String(time.month)+"/"+String(time.year)+"_"+String(time.hour) +":"+String(time.minute)+":"+String(time.second)
	return time_return
