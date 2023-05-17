class_name Chapter
extends Button


signal chapter_toggled(chapter, pressed)

export(String) var title := "Chapter Title"
export(String) var description := "Chapter description"
export(Array, Resource) var levels

onready var titleLabel = $MarginContainer/VBoxContainer/Title
onready var descriptionLabel = $MarginContainer/VBoxContainer/Description


func _ready():
	titleLabel.text = title
	descriptionLabel.text = description
	if disabled:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		modulate.a = 0.6
		hint_tooltip = "Coming soon..."
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		modulate.a = 1
		hint_tooltip = description


func _on_Chapter_pressed():
	emit_signal("chapter_toggled", self, pressed)
