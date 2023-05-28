extends Control
onready var page = find_node("PlayerNamePage") as Control
onready var submit = find_node("Submit") as Button
onready var nameEdit = find_node("NameEdit") as LineEdit
onready var mailEdit = find_node("MailEdit") as LineEdit
var player_name =""
var player_mail =""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_NameEdit_text_changed(new_text):
	submit.disabled = (new_text == "" or player_mail=="")
	player_name=new_text
pass # Replace with function body.


func _on_Submit_button_up():
	player_name = nameEdit.text
	player_mail= mailEdit.text
	Vars.store("player_name", player_name)
	Vars.store("player_mail", player_mail)
	ActionsData.save_action('NewGameStarted',player_mail)
	self.hide()
	#anim.play("hide")
	pass # Replace with function body.


func _on_MailEdit_text_changed(new_text):
	submit.disabled = (new_text == "" or player_name =="")
	pass # Replace with function body.
