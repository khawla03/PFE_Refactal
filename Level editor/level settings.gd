extends CanvasLayer


onready var LevelDescription = find_node("LevelDescription")
onready var levelTitle = find_node("levelTitle")
onready var sliderTitle = find_node("sliderTitle")
onready var slideContent = find_node("slideContent")

signal Next_pressed(title, description, sliderTitle,slideContent)





func _on_backButton_pressed():
	get_tree().change_scene("res://main/Main.tscn")
	pass # Replace with function body.


func _on_NextButton_pressed():
	emit_signal("Next_pressed",levelTitle.text, LevelDescription.text, sliderTitle.text,slideContent.text)
	pass # Replace with function body.
