extends MenuPanel


signal chapter_toggled(chapter, pressed)

onready var chapterContainer = $MarginContainer/VBoxContainer/ScrollContainer/Chapters


func _ready():
	Settings.connect("reset_progress", self, "hide")
	for chapter in chapterContainer.get_children():
		if chapter is Chapter:
			chapter.connect("chapter_toggled", self, "_on_chapter_toggled")


func hide():
	if active:
		.hide()
		yield(anim, "animation_finished")
		reset()


func reset():
	for chapter in chapterContainer.get_children():
		chapter.pressed = false


func _on_chapter_toggled(chapter, pressed):
	sound.play_sound(SoundPlayer.SWITCH)
	for child in chapterContainer.get_children():
		if child != chapter:
			child.pressed = false
	emit_signal("chapter_toggled", chapter, pressed)

