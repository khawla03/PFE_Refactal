extends Item


signal step_on()
signal step_out()

export(bool) var connect_step_on = false
export(bool) var connect_step_out = false



func _on_DetectArea_body_entered(body):
	if play_anim("on", true):
		emit_signal("step_on")


func _on_DetectArea_body_exited(body):
	if play_anim("off", true):
		emit_signal("step_out")


func apply_code():
	.apply_code()
	if connect_step_on:
		connect("step_on", code, "onStepOn")
	if connect_step_out:
		connect("step_out", code, "onStepOut")
