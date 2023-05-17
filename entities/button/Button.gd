class_name ButtonItem, "res://assets/icons/button.svg"
extends Item


signal pressed()

export(bool) var connect_pressed := false


func _init():
	icon = preload("res://assets/icons/ic_button.png")
	is_interactable = true
	interaction_message = "to press"


func _ready():
	highlight_meshes.append_array([$Mesh, $ButtonMesh])


func interact(player):
	play_anim("pressed")


func apply_code():
	.apply_code()
	if connect_pressed and Constraints.check_all():
		connect("pressed", code, "onButtonPressed")
