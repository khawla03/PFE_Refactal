extends CanvasLayer


signal connected()

func _ready():
	hide()


func show():
	$Root.show()


func hide():
	$Root.hide()


func _on_Button_button_up():
	$AnimationPlayer.play("connecting")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("connected")
