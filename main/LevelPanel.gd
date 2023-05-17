extends MenuPanel


signal level_toggled(levelInfo, pressed)

const LevelUI = preload("res://main/LevelUI.tscn")

var chapter: Chapter

onready var chapterTitleLabel = $MarginContainer/VBoxContainer/ChapterTitle
onready var levelContainer = $MarginContainer/VBoxContainer/ScrollContainer/Levels



func _ready():
	Settings.connect("reset_progress", self, "hide")


func show():
	if not active:
		chapterTitleLabel.text = chapter.title
		reset()
		for level in chapter.levels:
			var level_ui = LevelUI.instance()
			level_ui.level_info = level
			level_ui.connect("level_toggled", self, "_on_level_toggled")
			levelContainer.add_child(level_ui)
		.show()


func reset():
	NodeUtils.clear_children(levelContainer)


func _on_level_toggled(levelInfo, pressed):
	sound.play_sound(SoundPlayer.SWITCH)
	for level_ui in levelContainer.get_children():
		if level_ui.level_info != levelInfo:
			level_ui.pressed = false
	emit_signal("level_toggled", levelInfo, pressed)

