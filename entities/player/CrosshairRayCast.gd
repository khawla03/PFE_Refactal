extends RayCast


signal item_entred(item)
signal item_can_interact(can_interact)
signal item_exited()

var _was_aiming := false
var _was_near := false
var _last_collider := ""

onready var interactionRay := $InteractionRayCast


func _process(delta):
	if _is_aiming():
		if not _was_aiming or _last_collider != get_collider().display_name:
			_was_aiming = true
			_last_collider = get_collider().display_name
			emit_signal("item_entred", get_collider())
	elif not _is_aiming() and _was_aiming:
		_was_aiming = false
		emit_signal("item_exited")
	if _can_interact() and not _was_near:
		_was_near = true
		emit_signal("item_can_interact", true)
	elif not _can_interact() and _was_near:
		_was_near = false
		emit_signal("item_can_interact", false)
	pass


func _is_aiming() -> bool:
	return is_colliding() and get_collider().is_in_group("Item")


func _can_interact() -> bool:
	return interactionRay.is_colliding() and interactionRay.get_collider().is_in_group("Interactable")
