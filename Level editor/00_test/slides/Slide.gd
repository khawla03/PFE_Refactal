extends Control

onready var title=$HBox/Margin/VBox/VBox/Title as Label
onready var content=$HBox/Margin/VBox/VBox/Content as Label
var slideCont = ""
var slideTitle = ""
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	title.text=slideTitle
	content.text=slideCont
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
