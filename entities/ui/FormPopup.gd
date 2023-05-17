extends Control


const SHOW_DURATION = 0.3
const FORM_URL_FR = "https://forms.gle/sFFYb7JxdGSTcvdj9"
const FORM_URL_EN = "https://forms.gle/UMzvME3KS3E3La559"

var shown = false
export(float) var delay := 0.0


func show():
	if not Progress.is_all_levels_locked() and not shown and not Vars.in_game:
		shown = true
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.queue("show")


func hide():
	if shown:
		$AnimationPlayer.play("hide")
		shown = false


func _show_rect(node_path: NodePath):
	var tween = Tween.new()
	var node = get_node(node_path) as Control
	tween.interpolate_property(
		node,
		"rect_scale",
		Vector2(0, 1),
		Vector2(1, 1),
		SHOW_DURATION,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT,
		delay
	)
	tween.connect("tween_completed", tween, "queue_free")
	add_child(tween)
	tween.start()


func _hide_rect(node_path: NodePath):
	var tween = Tween.new()
	var node = get_node(node_path) as Control
	tween.interpolate_property(
		node,
		"rect_scale",
		Vector2(1, 1),
		Vector2(0, 1),
		SHOW_DURATION,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT,
		delay
	)
	tween.connect("tween_completed", tween, "queue_free")
	add_child(tween)
	tween.start()


func _on_French_button_up():
	OS.shell_open(FORM_URL_FR)
	hide()


func _on_English_button_up():
	OS.shell_open(FORM_URL_EN)
	hide()
