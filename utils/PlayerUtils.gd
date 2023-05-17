class_name PlayerUtils
extends Node


static func get_player(tree: SceneTree) -> Player:
	var players = tree.get_nodes_in_group("Player")
	if not players.empty():
		return players[0]
	else:
		return null


static func set_player_focus(tree: SceneTree, focus: bool):
	var players = tree.get_nodes_in_group("Player")
	var player = null
	if not players.empty():
		player = players[0]
	if player:
		player.focus_mode(focus)


static func set_discover_mode(tree: SceneTree, enabled: bool):
	var players = tree.get_nodes_in_group("Player")
	var player = null
	if not players.empty():
		player = players[0]
	if player:
		player.set_discover_mode(enabled)
