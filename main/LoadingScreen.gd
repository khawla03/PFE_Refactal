extends CanvasLayer


signal shown()

var label_text_state := 0

onready var anim = $AnimationPlayer
onready var loadingLabel = $LoadingLabel


func show():
	anim.play("show")


func hide():
	anim.play("hide")


func _on_LoadingTextChanger_timeout():
	match label_text_state:
		0:
			loadingLabel.text = "Loading."
			label_text_state += 1
		1:
			loadingLabel.text = "Loading.."
			label_text_state += 1
		2:
			loadingLabel.text = "Loading..."
			label_text_state += 1
		3:
			loadingLabel.text = "Loading"
			label_text_state = 0


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "show":
		emit_signal("shown")
