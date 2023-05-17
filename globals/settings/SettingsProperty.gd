class_name SettingsProperty
extends Control


export(String) var title: String
export(String) var settings_key: String
var value setget set_value


func _init():
	add_to_group("SettingsProperty")


func init():
	load_value()


func load_value():
	value = Settings.config.get(settings_key)


func set_value(val):
	value = val
	Settings.save_property(settings_key, value)

