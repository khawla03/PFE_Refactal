class_name DialogicUtils
extends Node

const Dialog = preload("res://addons/dialogic/Dialog.tscn")

static func start_dialog(parent: Node, timeline: String, method := "") -> Node:
	var dialog = Dialogic.start(timeline)
	parent.add_child(dialog)
	PlayerUtils.set_player_focus(parent.get_tree(), true)
	if method != "":
		dialog.connect("dialogic_signal", parent, method)
	return dialog

