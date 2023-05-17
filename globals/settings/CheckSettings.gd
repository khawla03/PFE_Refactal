extends SettingsProperty


export(String) var method: String

onready var checkButton = $CheckButton


func _ready():
	checkButton.text = title


func load_value():
	.load_value()
	checkButton.pressed = value
	Settings.call(method, value)


func set_value(val):
	.set_value(val)
	Settings.call(method, value)


func _on_CheckButton_toggled(button_pressed):
	set_value(button_pressed)
