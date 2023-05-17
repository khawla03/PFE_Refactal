class_name LimitArea
extends Area


var respawn_position: Vector3
var limits: Vector3

onready var collision := $CollisionShape


func _ready():
	collision.shape.extents.y = 1
	collision.shape.extents.x = limits.x
	collision.shape.extents.z = limits.z
	collision.translation.y = limits.y


func _on_LimitArea_body_entered(body):
	if body.is_in_group("Player"):
		body.translation = respawn_position
