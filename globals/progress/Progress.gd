extends Node


const SAVE_PATH = "user://progress.res"
const FILE_PASS = "REFACTALdemo092022"
const FinalScoreScreen = preload("res://levels/demo/FinalScore.tscn")
const Leaderboard = preload("res://entities/ui/LeaderBoard.tscn")

var levels_progress := {}


func _ready():
	SilentWolf.configure({
			  "api_key": "VynnJnNMZi1S2Ko1xqKpU14Waex7PNei2uBhorzF",
			  "game_id": "Refactal",
			  "game_version": Vars.GAME_VERSION,
			  "log_level": 0
			})
	_load_progress()
	print(get_total_score())


func save_level_progress(level_id: String, progress: Dictionary):
	levels_progress[level_id] = progress
	_save_progress()


func unlock_level(level_id):
	if not is_level_unlocked(level_id):
		levels_progress[level_id] = {
			"score": -1,
			"metrics": {
				"lines": -1,
				"minutes": -1,
				"seconds": -1,
				"cyc": -1
			}
		}
	_save_progress()


func is_level_completed(level_id):
	if is_level_unlocked(level_id):
		return levels_progress[level_id].get("score") != -1
	return false


func is_level_unlocked(level_id):
	return levels_progress.get(level_id) != null


func is_level_locked(level_id):
	return not levels_progress.has(level_id)


func is_all_levels_locked():
	return levels_progress.empty()


func get_level_score(level_id):
	if is_level_completed(level_id):
		return levels_progress.get(level_id).get("score")
	return null


func get_total_score():
	var total = 0
	for key in levels_progress.keys():
		if levels_progress.get(key)["score"] != -1:
			total += levels_progress.get(key)["score"]
	return total


func get_level_lines(level_id):
	if is_level_completed(level_id):
		if levels_progress.get(level_id):
			if levels_progress.get(level_id).get("metrics"):
				return levels_progress.get(level_id).get("metrics").get("lines")
	return null


func get_level_time(level_id):
	if is_level_completed(level_id):
		return {
			"minutes": levels_progress.get(level_id).get("metrics").get("minutes"),
			"seconds": levels_progress.get(level_id).get("metrics").get("seconds")
		}
	else:
		return null


func get_level_minutes(level_id):
	if is_level_completed(level_id):
		if levels_progress.get(level_id):
			if levels_progress.get(level_id).get("metrics"):
				return levels_progress.get(level_id).get("metrics").get("minutes")
	return null


func get_level_seconds(level_id):
	if is_level_completed(level_id):
		if levels_progress.get(level_id):
			if levels_progress.get(level_id).get("metrics"):
				return levels_progress.get(level_id).get("metrics").get("seconds")
	return null



func get_level_cyc(level_id):
	if is_level_completed(level_id):
		if levels_progress.get(level_id):
			if levels_progress.get(level_id).get("metrics"):
				return levels_progress.get(level_id).get("metrics").get("cyc")
	return null



func reset_progress():
	levels_progress.clear()
	_save_progress()


func submit_score(player_name, score):
	Vars.store("player_name", player_name)
	Vars.store("submitted_score", score)
	var score_id = yield(SilentWolf.Scores.persist_score(player_name, int(score)), "sw_score_posted")
	Vars.store("score_id", score_id)


func show_submit_screen():
	var screen = FinalScoreScreen.instance()
	add_child(screen)


func show_leaderboard():
	var board = Leaderboard.instance()
	add_child(board)


func _load_progress():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		file.open_encrypted_with_pass(SAVE_PATH, File.READ, FILE_PASS)
		levels_progress = str2var(file.get_as_text())
		file.close()


func _save_progress():
	var file = File.new()
	file.open_encrypted_with_pass(SAVE_PATH, File.WRITE, FILE_PASS)
	file.store_string(var2str(levels_progress))
	file.close()

