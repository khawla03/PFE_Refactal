extends Spatial


signal shake_camera()
signal finished()

var animations = ["first", "second", "third"]
var anim_idx = -1

onready var anim = $AnimationPlayer


func _ready():
	next_anim()


func next_anim():
	anim_idx += 1
	if anim_idx < animations.size():
		 anim.play(animations[anim_idx])


func start_dialogue():
	var dialog = DialogicUtils.start_dialog(self, "intro")
	dialog.connect("dialogic_signal", self, "_on_dialog_finished")


func _on_AnimationPlayer_animation_finished(anim_name):
	next_anim()


func _on_dialog_finished(argument):
	emit_signal("finished")
	queue_free()
	queue_free()


func _on_Skip_button_up():
	emit_signal("finished")
	queue_free()
