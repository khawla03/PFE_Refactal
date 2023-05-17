extends Camera

const IntroStory = preload("res://story/intro/IntroStory.tscn")
const ScreenShake = preload("res://entities/camera/ScreenShake.tscn")

export(float) var rotation_speed = 0.01


func _process(delta: float) -> void:
	rotate_y(-rotation_speed * delta)


func _on_LevelLoader_started_loading():
	current = false
	set_process(false)


func _on_LevelLoader_return_to_menu():
	current = true
	set_process(true)


func _on_MainPanel_new_game():
#	set_process(false)
	var introStory = IntroStory.instance()
	introStory.connect("shake_camera", self, "shake_camera")
	introStory.connect("switch_camera", self, "switch_camera")
	introStory.connect("finished", get_parent(), "_on_intro_story_finished")
	add_child(introStory)


func shake_camera():
	var screenShake = ScreenShake.instance()
	add_child(screenShake)
	screenShake.shake(true, 1, 15, 1)


func switch_camera():
	current = false
