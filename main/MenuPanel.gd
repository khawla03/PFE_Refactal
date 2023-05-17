class_name MenuPanel
extends Panel


signal hidden()
signal shown()

const SoundPlayerScene = preload("res://entities/sound/SoundPlayer.tscn")

var active := false
var pos: Vector2

onready var anim: AnimationPlayer = $AnimationPlayer
onready var posTween: Tween = $PositionTween
onready var sound: SoundPlayer = SoundPlayerScene.instance()


func _ready():
	pos = rect_position
	anim.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	posTween.connect("tween_all_completed", self, "_on_posTween_all_completed")
	add_child(sound)


func show():
	if not active:
		active = true
		anim.play("show")


func hide():
	if active:
		active = false
		anim.play("hide")


func animate_position(show := true):
	var finalPos = pos
	var initialPos = finalPos + Vector2(-10, 0)
	if show:
		posTween.interpolate_property(self, "rect_position", initialPos, finalPos, 0.3, Tween.TRANS_QUAD)
	else:
		posTween.interpolate_property(self, "rect_position", finalPos, initialPos, 0.3, Tween.TRANS_QUAD)
	posTween.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		emit_signal("hidden")
	if anim_name == "show":
		emit_signal("shown")


func _on_posTween_all_completed():
#	rect_position = pos
	pass
