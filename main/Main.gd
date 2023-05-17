extends Node


onready var levelLoader = find_node("LevelLoader") as LevelLoader
onready var music = find_node("MainMusic") as Music


func _on_intro_story_finished():
	levelLoader.start_level("res://levels/tutorial/Controls/ControlsTutorial.tscn")


func _on_MainPanel_new_game():
	music.pause_music()

