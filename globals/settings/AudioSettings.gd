extends SettingsProperty


export(String) var settings_mute_key
export(String) var audio_bus_name: String

var bus_idx = null

onready var titleLabel = $Title
onready var slider = $HSlider


func _ready():
	titleLabel.text = title
	if audio_bus_name and audio_bus_name != "":
		bus_idx = AudioServer.get_bus_index(audio_bus_name)
		slider.connect("value_changed", self, "_on_slider_value_changed")


func load_value():
	.load_value()
	slider.value = value


func _on_slider_value_changed(val):
	set_value(val)
	if value > slider.min_value:
		AudioServer.set_bus_volume_db(bus_idx, val)
		AudioServer.set_bus_mute(bus_idx, false)
		Settings.save_property(settings_mute_key, false)
	else:
		AudioServer.set_bus_mute(bus_idx, true)
		Settings.save_property(settings_mute_key, true)
