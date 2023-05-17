class_name OxBottlesItem
extends Item

signal interact(oxBottles, player)

export(bool) var connect_interaction := false
var is_full = false
var is_empty = true
# Called when the node enters the scene tree for the first time.
func _ready():
	self.empty()
	pass # Replace with function body.

func empty():
	is_empty=true
	is_full = false
	play_anim("empty")

func fill():
	is_empty=false
	is_full = true
	play_anim("Fill")

func interact(player):
	emit_signal("interact", self, player)
	print("interacted")


func apply_code():
	.apply_code()
	if connect_interaction:
		print("applied")
		connect("interact", code, "onInteract")
		print("connected")
