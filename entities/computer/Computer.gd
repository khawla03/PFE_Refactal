class_name Computer, "res://assets/icons/computer.svg"
extends Item


signal started_coding(player)

export(bool) var active := true

onready var mesh = $Mesh


func _init():
	icon = preload("res://assets/icons/ic_computer.png")
	is_interactable = true
	interaction_message = "Use"


func _ready():
	highlight_meshes.append(mesh)
	display_name = "Computer"
	description = "Use this computer to program objects"
	interaction_message = "to use"
	if active:
		connect(
			"started_coding", 
			get_tree().get_nodes_in_group("Level")[0], 
			"_on_started_coding")


func interact(player):
	ActionsData.save_action('Computer pressed')
	emit_signal("started_coding", player)
