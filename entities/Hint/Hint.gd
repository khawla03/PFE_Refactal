class_name Hints
extends CanvasLayer


signal hidden()

export(Array, PackedScene) var slide_scenes
export(bool) var disable_focus_when_hidden = true

var title: String setget set_title
var slides := []
var index = 0
var paused = false

onready var rootControl = $Background
onready var titleLabel = $Background/MarginContainer/VBoxContainer/Title
onready var slideContainer = $Background/MarginContainer/VBoxContainer/Slide
onready var nextButton = $Background/MarginContainer/VBoxContainer/HBoxContainer/Next
onready var previousButton = $Background/MarginContainer/VBoxContainer/HBoxContainer/Previous
onready var anim = $AnimationPlayer


func _init():
	add_to_group("Hints")


func _ready():
	for scene in slide_scenes:
		slides.append(scene.instance())
	update_ui()


func _input(event):
	if event.is_action_pressed("exit") and rootControl.visible and not paused:
		hide()
		paused = true


func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	paused = false
	anim.play("show")


func hide():
	anim.play("hide")
	emit_signal("hidden")
	if disable_focus_when_hidden:
		PlayerUtils.set_player_focus(get_tree(), false)


func update_ui():
	titleLabel.text = title
	if index == (slides.size() - 1):
		nextButton.text = "Done"
	else:
		nextButton.text = "Next >"
	previousButton.visible = index != 0
	slideContainer.add_child(slides[index])


func set_title(t):
	title = t
	titleLabel.text = t


func _on_Next_pressed():
	slideContainer.remove_child(slides[index])
	index += 1
	if index == slides.size():
		hide()
		index=0
		update_ui()
	else:
		update_ui()


func _on_Previous_pressed():
	slideContainer.remove_child(slides[index])
	if index != 0:
		index -= 1
		update_ui()

