extends Control


signal intro_finished()

var animations = ["fade_splash", "esi", "godot"]
var anim_idx = -1
var finished = false

onready var anim = $AnimationPlayer


func _ready():
	next_anim()


func _input(event):
	if (
		event is InputEventKey
		or (event is InputEventMouseButton and event.is_pressed())
		and anim_idx != 0):
		next_anim()


func next_anim():
	if finished: 
		return
	anim_idx += 1
	if anim_idx < animations.size():
		anim.play(animations[anim_idx])
	else:
		anim.play("RESET")
		finished = true
		emit_signal("intro_finished")
		queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	next_anim()
