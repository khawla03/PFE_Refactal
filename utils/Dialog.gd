class_name Dialog
extends Reference


const ConfirmDialog = preload("res://entities/dialogs/ConfirmDialog.tscn")


static func show_confirm_dialog(
		message: String, 
		action: FuncRef, 
		container: Node,
		hide_after_confirm := false
		):
	var dialog = ConfirmDialog.instance()
	dialog.hide_after_confirm = hide_after_confirm
	dialog.message = message
	dialog.action = action
	container.add_child(dialog)
