extends Node

signal connected()
signal disconnected()

export var websocket_url = "ws://141.144.243.155:9080/"

var _client = WebSocketClient.new()
var is_connected = false
var retry_to_connect = true

onready var reconnectTimer = $ReconnectTimer


func _ready():
#	_client.verify_ssl = false
#	_client.trusted_ssl_certificate = certif
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")


func parse(script: String, name: String):
	var query = {"object_name": name, "script": script}
	_client.get_peer(1).put_packet(JSON.print(query).to_utf8())


func connect_client():
	set_process(true)
	retry_to_connect = true
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect to the server (error code %d)" % err)
		reconnectTimer.start()
	else:
		print("Connecting to the server...")


func disconnect_client():
	set_process(false)
	retry_to_connect = false
	_client.disconnect_from_host()
	print("Disconnected from the server")


func _on_data():
	var pkt = _client.get_peer(1).get_packet()
	var result = JSON.parse(pkt.get_string_from_utf8()).result
	var name = result["object_name"]
	for item in get_tree().get_nodes_in_group("Programmable"):
		if item.display_name == name:
			item.set_error(result)
			break


func _closed(was_clean = false):
	retry_to_connect = true
	is_connected = false
	emit_signal("disconnected")
	reconnectTimer.start()
	print("Connexion to the server closed. Clean: ", was_clean)


func _connected(proto = ""):
	reconnectTimer.stop()
	retry_to_connect = false
	is_connected = true
	emit_signal("connected")
	print("Connected to the server successfully")


func _process(delta):
	_client.poll()


func _on_ReconnectTimer_timeout():
	if retry_to_connect:
		connect_client()
