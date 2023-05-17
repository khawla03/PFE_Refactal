tool
extends Item


signal on()
signal reset()
signal completed()

const BulbScene = preload("res://entities/doors/Bulb.tscn")

export(int) var lights := 0 setget set_lights
export(bool) var update := false setget update_viewport

var bulbs := []
var bulbs_on := 0
var animating = false

onready var bulbsContainer = $Bulbs


func _ready():
	update_lights()


func fire():
	if bulbs_on < bulbs.size():
		bulbs[bulbs_on].on()
		animating = true
		yield(bulbs[bulbs_on], "on")
		animating = false
		emit_signal("on")
		bulbs_on += 1
		if bulbs_on == bulbs.size():
			completed()


func reset():
	for bulb in bulbs:
		bulb.off()
	yield(bulbs[0], "off")
	emit_signal("reset")
	bulbs_on = 0


func completed():
	play_anim("completed")
	for bulb in bulbs:
		bulb.completed()
	yield(bulbs[0], "completed")
	emit_signal("completed")


func set_lights(num: int):
	lights = num


func update_lights():
	NodeUtils.clear_children(bulbsContainer)
	bulbs.clear()
	for i in lights:
		_new_bulb(i)


func update_viewport(enabled=false):
	if enabled:
		update = false
		update_lights()
		notification(NOTIFICATION_READY)


func _new_bulb(index):
	var bulb = BulbScene.instance()
	bulbs.append(bulb)
	bulb.name = str(index)
	bulb.translation.x = index * 0.28
	bulbsContainer.add_child(bulb)
	bulb.set_owner(bulbsContainer)

