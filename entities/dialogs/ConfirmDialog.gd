extends CanvasLayer


var message: String
var action: FuncRef
var hide_after_confirm := false

onready var confirmButton = $Root/VBoxContainer/HBoxContainer/ConfirmButton
onready var cancelButton = $Root/VBoxContainer/HBoxContainer/CancelButton
onready var messageLabel = $Root/VBoxContainer/Label
onready var anim = $AnimationPlayer
onready var root = $Root



func _ready():
	messageLabel.text = message
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_ConfirmButton_pressed():
	confirmButton.disabled = true
	cancelButton.disabled = true
	action.call_func()
	if hide_after_confirm:
		root.hide()
		queue_free()
	else:
		anim.play("hide")


func _on_CancelButton_pressed():
	queue_free()
