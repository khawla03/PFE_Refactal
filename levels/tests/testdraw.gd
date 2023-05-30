extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _draw():
	draw_line(Vector2(1, 1.0), Vector2(1.5, 4.0), Color.aqua, 1.0)
	pass
func _process(delta):
	update()
# Called when the node enters the scene tree for the first time.
func _ready():
	draw_line(Vector2(1, 1.0), Vector2(1.5, 4.0), Color.aqua, 1.0)
	draw_rect(Rect2(1.0, 1.0, 3.0, 3.0), Color.aqua)
	pass # Replace with function body.
