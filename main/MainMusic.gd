extends Music



func _ready():
	play_music(true, 4)


func _on_LevelLoader_return_to_menu():
	resume_music(true, 4)


func _on_LevelLoader_level_loaded():
	pause_music()
