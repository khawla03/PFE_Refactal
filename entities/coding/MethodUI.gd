extends ColorRect


signal method_pressed(method)

var method: String setget set_method
onready var label := $MarginContainer/HBoxContainer/Label


func _ready():
	label.text = method


func set_method(method_name: String):
	method = method_name
	


func _on_MethodUI_mouse_entered():
	color.a = 0.2


func _on_MethodUI_mouse_exited():
	color.a = 0


func _on_MethodUI_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("method_pressed", method)
