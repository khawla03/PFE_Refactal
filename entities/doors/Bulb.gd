class_name Bulb
extends MeshInstance


signal on()
signal off()
signal completed()

var is_on := false

onready var anim = $AnimationPlayer


func _init():
	var mat = mesh.surface_get_material(1)
	mesh.surface_set_material(1, mat.duplicate())


func on():
	anim.play("on")


func off():
	anim.play("off")


func completed():
	anim.play("completed")
