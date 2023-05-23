extends Control
onready var page = find_node("PlayerNamePage") as Control
onready var submit = find_node("Submit") as Button
onready var nameEdit = find_node("NameEdit") as LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_NameEdit_text_changed(new_text):
	submit.disabled = new_text == ""
pass # Replace with function body.


func _on_Submit_button_up():
	var player_name = nameEdit.text
	Vars.store("player_name", player_name)
	ActionsData.save_action('NewGameStarted',player_name)
	self.hide()
	#anim.play("hide")
	pass # Replace with function body.
