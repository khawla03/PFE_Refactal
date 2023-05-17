class_name ItemUI
extends ColorRect


signal item_pressed(itemElement)
signal rename(item_ui)
signal item_freed(item_name)

const OPTION_COPY_REF = 0
const OPTION_RENAME = 1
const OPTION_DELETE = 2

export(Color) var text_color: Color
export(Color) var highlight_color: Color
export(Color) var hover_color: Color

var item : Item
var is_custom := false
var last_popup_press := 0.0

onready var iconTexture = $MarginContainer/HBoxContainer/TextureRect
onready var nameLabel = $MarginContainer/HBoxContainer/Label
onready var menuButton = $MarginContainer/HBoxContainer/MenuButton
onready var optionsPopup = $ItemOptions
onready var lockIcon = $MarginContainer/HBoxContainer/Lock
onready var errorIcon = $MarginContainer/HBoxContainer/Error


func _ready():
	update_ui()
	lockIcon.visible = item.locked
	if not is_custom:
		for id in [OPTION_RENAME, OPTION_DELETE]:
			optionsPopup.set_item_disabled(optionsPopup.get_item_index(id), true)
	item.connect("parse_status_changed", self, "_on_item_error_changed")


func update_ui():
	if item:
		iconTexture.texture = item.icon
		nameLabel.text = item.display_name
		hint_tooltip = item.description
		errorIcon.visible = item.has_error


func queue_free():
	item.queue_free()
	.queue_free()


func set_highlight(enabled: bool):
	if enabled:
		nameLabel.set("custom_colors/font_color", highlight_color)
		iconTexture.material.set_shader_param("color", highlight_color)
	else:
		nameLabel.set("custom_colors/font_color", text_color)
		iconTexture.material.set_shader_param("color", text_color)


func save_code(new_source: String):
	item.save_code(new_source)


func _on_ItemListElement_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("item_pressed", self)
		elif event.pressed and event.button_index == BUTTON_RIGHT:
			optionsPopup.set_position(event.global_position)
			optionsPopup.popup()


func _on_ItemListElement_mouse_entered():
	color = hover_color


func _on_ItemListElement_mouse_exited():
	color = Color.transparent


func _on_MenuButton_pressed():
	optionsPopup.set_position(menuButton.rect_global_position)
	optionsPopup.popup()


func _on_ItemOptions_id_pressed(id):
	if OS.get_ticks_msec() - last_popup_press < 100:
		return
	last_popup_press = OS.get_ticks_msec()
	match id:
		OPTION_COPY_REF:
			OS.clipboard = "getObject(\"" + item.display_name + "\")"
		OPTION_RENAME:
			emit_signal("rename", self)
		OPTION_DELETE:
			Dialog.show_confirm_dialog(
				"Delete \"" + item.display_name + "\" object?",
				funcref(self, "queue_free"),
				get_tree().root,
				true
			)


func _on_item_error_changed(item):
	errorIcon.visible = item.has_error
