class_name PlayerSpawner
extends Position3D


func add_player(player: Player, focus_mode = false):
	player.is_interacting = focus_mode
	add_child(player)
