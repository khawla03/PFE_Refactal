tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _draw():
	draw_line(Vector2(100, 100), Vector2(100, 400), Color.aqua, 1.0)
	draw_circle(Vector2(100, 100),10,Color.aqua)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
