extends CanvasLayer


onready var rootControl = $Background
onready var mainPanel = $Background/HBoxContainer/MainPanel
onready var chapterPanel = $Background/HBoxContainer/ChapterPanel
onready var levelPanel = $Background/HBoxContainer/LevelPanel
onready var levelDetailPanel = $Background/HBoxContainer/LevelDetailPanel
onready var playerNamePage=$PlayerNamePage

#var levelEditor = preload("res://Level editor/LevelEditor.tscn").instance()
#
func _ready():
	ActionsData.save_action('GameStarted',"Number of levels passed: "+str(Progress.levels_progress.size()))
	
	Vars.clear_vars()

func _on_MainPanel_level_button_toggled(pressed: bool):
	if pressed:
		chapterPanel.show()
	else:
		for panel in [levelDetailPanel, levelPanel, chapterPanel]:
			if panel.active:
				panel.hide()
				yield(panel, "hidden")



func _on_ChapterPanel_chapter_toggled(chapter, pressed):
	if levelDetailPanel.active:
		levelDetailPanel.hide()
		yield(levelDetailPanel, "hidden")
	if pressed:
		if levelPanel.active:
			levelPanel.hide()
			yield(levelPanel, "hidden")
		levelPanel.chapter = chapter
		levelPanel.show()
	else:
		levelPanel.hide()


func _on_LevelPanel_level_toggled(levelInfo, pressed):
	if pressed:
		if levelDetailPanel.active:
			levelDetailPanel.hide()
			yield(levelDetailPanel, "hidden")
		levelDetailPanel.level_info = levelInfo
		levelDetailPanel.show()
	else:
		levelDetailPanel.hide()



func _on_LevelLoader_started_loading():
	for panel in [levelDetailPanel, levelPanel, chapterPanel, mainPanel]:
		panel.hide()


func _on_LevelLoader_return_to_menu():
#	rootControl.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mainPanel.show()
	mainPanel.init_buttons()
	if Vars.show_submit_screen:
		Progress.show_submit_screen()


func _on_Intro_intro_finished():
	if Vars.get_var("player_name")==null:
		playerNamePage.show()
	mainPanel.show()


func _on_MainPanel_new_game():
	for panel in [levelDetailPanel, levelPanel, chapterPanel, mainPanel]:
		panel.hide()


func _on_MainPanel_leaderboard():
	Progress.show_leaderboard()


#
#func _on_MainPanel_leveleditor():
#	for panel in [levelDetailPanel, levelPanel, chapterPanel, mainPanel]:
#		panel.hide()
#	var lvledit = ResourceLoader.load("res://Level editor/LevelEditor.tscn").instance()
#	get_tree().get_root().add_child(lvledit)
#
#	pass # Replace with function body.
