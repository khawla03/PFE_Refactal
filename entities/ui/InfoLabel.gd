extends RichTextLabel


const ANIMATION_DURATION = 0.3

export(Array, Resource) var infos := []

onready var infoLabel = find_node("Info") as RichTextLabel
onready var tween = find_node("Tween") as Tween


func _ready():
	infoLabel.rect_scale = Vector2.ZERO


func show_info(text):
	infoLabel.text = text
	infoLabel.rect_position = _get_show_position()
	var current_scale = infoLabel.rect_scale
	tween.interpolate_property(
		infoLabel,
		"rect_scale",
		current_scale,
		Vector2(1, 1),
		ANIMATION_DURATION,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	tween.start()


func hide_info():
	var current_scale = infoLabel.rect_scale
	tween.interpolate_property(
		infoLabel,
		"rect_scale",
		current_scale,
		Vector2.ZERO,
		ANIMATION_DURATION,
		Tween.TRANS_BACK,
		Tween.EASE_IN
	)
	tween.start()


func _get_show_position():
	var mouse_pos = get_global_mouse_position()
	var mid_screen_x = get_viewport_rect().size.x / 2
	var mid_screen_y = get_viewport_rect().size.y / 2
	if mouse_pos.x < mid_screen_x and mouse_pos.y < mid_screen_y:
		infoLabel.rect_pivot_offset.x = 0
		infoLabel.rect_pivot_offset.y = 0
		return mouse_pos
	if mouse_pos.x >= mid_screen_x and mouse_pos.y < mid_screen_y:
		infoLabel.rect_pivot_offset.x = infoLabel.rect_size.x
		infoLabel.rect_pivot_offset.y = 0
		return mouse_pos + Vector2(-infoLabel.rect_size.x, 0)
	if mouse_pos.x < mid_screen_x and mouse_pos.y >= mid_screen_y:
		infoLabel.rect_pivot_offset.x = 0
		infoLabel.rect_pivot_offset.y = infoLabel.rect_size.y
		return mouse_pos + Vector2(0, -infoLabel.rect_size.y)
	if mouse_pos.x >= mid_screen_x and mouse_pos.y >= mid_screen_y:
		infoLabel.rect_pivot_offset.x = infoLabel.rect_size.x
		infoLabel.rect_pivot_offset.y = infoLabel.rect_size.y
		return mouse_pos + Vector2(-infoLabel.rect_size.x, -infoLabel.rect_size.y)


func _on_InfoLabel_meta_hover_started(meta):
	for info in infos:
		if info.key == meta:
			show_info(info.text)
		break


func _on_InfoLabel_meta_hover_ended(meta):
	hide_info()

