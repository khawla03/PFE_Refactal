extends Node

signal connected()
signal disconnected()

export(String) var url = "141.144.243.155"
export(int) var port = 9080

var _client = NetworkedMultiplayerENet.new()
var is_connected = false
var retry_to_connect = true

onready var reconnectTimer = $ReconnectTimer


func _ready():
	_client.dtls_verify = false
	_client.connect("connection_failed", self, "_connection_failed")
	_client.connect("connection_succeeded", self, "_connection_succeeded")
	_client.connect("server_disconnected", self, "_server_disconnected")

func parse(script: String, name: String):
	rpc_id(1, "parse", script, name)


remote func set_error(result):
	var object_name = result["object_name"]
	for item in get_tree().get_nodes_in_group("Programmable"):
		if item.display_name == object_name:
			item.set_error(result)
			break


func connect_client():
	retry_to_connect = true
	var err = _client.create_client(url, port)
	get_tree().set_network_peer(_client)
	if err != OK:
		print("Unable to connect to the server (error code %d)" % err)
		reconnectTimer.start()
	else:
		print("Connecting to the server...")


func disconnect_client():
	retry_to_connect = false
	_client.disconnect_peer(get_tree().get_network_unique_id())
	print("Disconnected from the server")


func _server_disconnected():
	retry_to_connect = true
	is_connected = false
	emit_signal("disconnected")
	reconnectTimer.start()
	print("Connexion to the server closed")


func _connection_succeeded():
	reconnectTimer.stop()
	retry_to_connect = false
	is_connected = true
	emit_signal("connected")
	print("Connected to the server successfully")


func _connection_failed():
	retry_to_connect = true
	is_connected = false
	emit_signal("disconnected")
	reconnectTimer.start()
	print("Connexion to the server failed")


func _on_ReconnectTimer_timeout():
	if retry_to_connect:
		connect_client()
