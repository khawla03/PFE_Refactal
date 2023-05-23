class_name Level, "res://assets/icons/level.svg"
extends Spatial


export(Resource) var level_info 
export(bool) var show_level_report = true
export(NodePath) var slider
export(NodePath) var map
export(NodePath) var spawner
export(NodePath) var hints

const DISCOVER_MAT_ITEM = preload("res://assets/materials/discover_item_mat.tres")

const PlayerSpawnerScene = preload("res://entities/level/PlayerSpawner.tscn")
const PlayerScene = preload("res://entities/player/Player.tscn")
const LimitAreaScene = preload("res://entities/level/LimitArea.tscn")
const CodeGUI = preload("res://entities/coding/CodeGUI.tscn")
const CompleteScreen = preload("res://entities/level/CompleteScreen.tscn")
const MusicScene = preload("res://entities/music/Music.tscn")
const LevelTimerScrene = preload("res://entities/level/LevelTimer.tscn")

onready var playerSpawner : PlayerSpawner
onready var limitArea := LimitAreaScene.instance()
onready var codingGUI := CodeGUI.instance()
onready var music := MusicScene.instance()
onready var levelTimer := LevelTimerScrene.instance()
var lines_init=0
var bonus = 0


func _init():
	add_to_group("Level")


func queue_free():
	remove_from_group("Level")
	for child in get_children():
		child.queue_free()
	.queue_free()


func _ready():
	var metrics = get_metrics()
#	if not type_exists("GDScriptParserWrap"):
#		Server.connect_client()
	if level_info!= null:
		ActionsData.save_action('start level',level_info.title)
	# Player spawner
	if get_node(spawner):
		playerSpawner = get_node(spawner)
	# CodeGui
	codingGUI.level = self
	add_child(codingGUI)
	# Music
	music.type = Music.MUSIC_IN_GAME
	add_child(music)
	music.play_music(true, 10)
	# Create player
	var new_player = PlayerScene.instance()
	new_player.connect("resumed", self, "_on_game_resumed")
	new_player.connect("exit_coding", self, "_on_exit_coding")
	new_player.connect("Hint", self, "_on_Hint")
	codingGUI.connect("exit_coding", new_player, "stop_coding")
	if get_node(map):
		new_player.connect("discover_mode", self, "_on_discover_mode")
	playerSpawner.add_player(new_player, slider != "")
	# Slider
	if slider:
		var slider_node = get_node(slider)
		slider_node.title = level_info.title + ": " + level_info.shortDescription
		slider_node.connect("hidden", self, "_on_slider_hidden")
		if slider_node.auto_show:
			slider_node.show()
	# Timer
	add_child(levelTimer)
	if not slider:
		levelTimer.start()
	Constraints.show()
	lines_init=metrics["lines"]


func _exit_tree():
#	Server.disconnect_client()
	Constraints.hide()
	remove_from_group("Level")


func _on_started_coding(player):
	player.focus_mode(true)
	codingGUI.start_coding()
	ActionsData.save_action('Start coding','')


func _on_exit_coding(player):
	player.focus_mode(false)
	codingGUI.stop_coding()
	ActionsData.save_action('Exit coding','')


func _on_slider_hidden():
	levelTimer.start()


func return_to_menu():
	music.stop_music()
	get_parent().free_level()
	ActionsData.save_action('Go to main menu','returned to main menu from '+level_info.title)

func restart():
	music.stop_music()
	get_parent().restart_level()
	ActionsData.save_action('Level restarted',level_info.title)


func next_level():
	music.stop_music()
	get_parent().next_level(level_info.next_level.path)


func end_level(player):
	
	levelTimer.stop()
	levelTimer.hide()
	player.focus_mode(true)
	var complete = CompleteScreen.instance()
	complete.show_level_report = show_level_report
	var metrics = get_metrics()
	var score = Score.calc_score(
		metrics["lines"],
		metrics["cyc"],
		metrics["minutes"],
		metrics["seconds"]
	) + float(bonus)
	print(Score.calc_score(metrics["lines"],metrics["cyc"],metrics["minutes"],metrics["seconds"]) )
	print(bonus)
	ActionsData.save_action('Level passed',"Score:" + str(score))
	complete.score = score
	complete.metrics = metrics
	complete.connect("return_to_menu", self, "return_to_menu")
	complete.connect("restart_level", self, "restart")
	complete.connect("next_level", self, "next_level")
	add_child(complete)
	
	# save progress
	if not show_level_report:
		Progress.unlock_level(level_info.id)
	elif Progress.is_level_completed(level_info.id):
		var last_score = Progress.get_level_score(level_info.id)
		var last_lines = Progress.get_level_lines(level_info.id)
		var last_cyc = Progress.get_level_cyc(level_info.id)
		var last_time = Progress.get_level_time(level_info.id)
		var last_time_secs = last_time["minutes"]*60 + last_time["seconds"]
		var time_secs = metrics["minutes"]*60 + metrics["seconds"]
		var best_metrics = {
			"lines": min(metrics["lines"], last_lines),
			"minutes": last_time["minutes"] if last_time_secs < time_secs else metrics["minutes"],
			"seconds": last_time["seconds"] if last_time_secs < time_secs else metrics["seconds"],
			"cyc": min(metrics["cyc"],last_cyc)
		}
		Progress.save_level_progress(level_info.id, {
			"score": max(score, last_score),
			"metrics": best_metrics
		})
	else:
		Progress.save_level_progress(level_info.id, {
			"score": score,
			"metrics": metrics
		})
	if not level_info.next_level.path.empty() and not Progress.is_level_completed(level_info.next_level.id):
		Vars.store("next_level", level_info.next_level.path)
	if level_info.next_level:
		Progress.unlock_level(level_info.next_level.id)


func get_metrics():
	return {
		"lines": MetricUtils.total_line_count(get_tree())-lines_init,
		"cyc":MetricUtils.total_cyc(get_tree()),
		"seconds": levelTimer.seconds,
		"minutes": levelTimer.minutes
	}


func _on_game_resumed(player):
	if get_node(slider):
		if get_node(slider).paused:
			get_node(slider).show()
			return
	player.focus_mode(false)
	ActionsData.save_action('Level resumed',level_info.title)


func _on_discover_mode(enabled):
	if enabled:
		ActionsData.save_action('Discover mode entered',level_info.title)
		get_node(map).set_discover_mode(true)
		for mesh in get_tree().get_nodes_in_group("ItemMesh"):
			for index in mesh.get_surface_material_count():
				mesh.set_surface_material(index, DISCOVER_MAT_ITEM)
	else:
		get_node(map).set_discover_mode(false)
		for mesh in get_tree().get_nodes_in_group("ItemMesh"):
			for index in mesh.get_surface_material_count():
				mesh.set_surface_material(index, null)

#__________________________________________________

func _on_Hint(player):
	if get_node(hints):
		get_node(hints).show()
