extends Button


signal level_toggled(levelInfo, pressed)

var level_info: LevelInfo
var locked = true

onready var titleLabel := find_node("Title") as Label
onready var shortDescLabel := find_node("ShortDesciption") as RichTextLabel
onready var lockIcon = find_node("Lock") as TextureRect


func _ready():
	locked = Progress.is_level_locked(level_info.id)
	titleLabel.text = level_info.title
	shortDescLabel.text = level_info.shortDescription
	if level_info.shortDescription == "":
		shortDescLabel.visible = false
	disabled = locked
	lockIcon.visible = locked
	titleLabel.modulate.a = 0.5 if locked else 1
	shortDescLabel.modulate.a = 0.5 if locked else 1
	mouse_default_cursor_shape = Control.CURSOR_ARROW if locked else Control.CURSOR_POINTING_HAND


func _on_LevelUI_pressed():
	emit_signal("level_toggled", level_info, pressed)
