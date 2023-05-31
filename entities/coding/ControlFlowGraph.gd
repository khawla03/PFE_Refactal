tool
extends Control

var points := []
var ligns :=[]
var font = load('res://assets/fonts/default.tres')

func _draw():

	draw_string(font, Vector2(410, 100), "Func",Color.aqua)
	draw_line(Vector2(400, 100), Vector2(400, 400), Color.aqua, 1.5)
	draw_circle(Vector2(400, 100),10,Color.aqua)
	pass



func _ready():
	update()
	pass # Replace with function body.
