extends ColorRect





func _on_DialogBg_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			hide()
