extends Node

const IS_SERVER = false
var BEN_IP = "192.168.42.63"
var PIA_IP = "192.168.42.100"
var GAB_IP = "192.168.42.124"
var width = ProjectSettings.get_setting("display/window/size/width")
var height = ProjectSettings.get_setting("display/window/size/height")
var timer = 0
signal object_received

## Object Dict specification:
# {
#   "name": String,
#	"pos": Vector2,
#   "vel": Vector2,
# }

func send_object(object_dict):
	var rel = object_dict["pos"]
	rel.x /= width
	rel.y /= height
	object_dict["pos"] = rel
	rpc("receive_foreign_object", get_tree().get_network_unique_id(), object_dict)

remote func receive_foreign_object(player_name, object_dict):
	print(player_name)
	print(object_dict)
	var abs_pos = object_dict["pos"]
	abs_pos.x *= width
	abs_pos.y *= height
	object_dict["pos"] = abs_pos
	emit_signal("object_received", object_dict)

func _ready():
	var peer
	if IS_SERVER:
		host_server()
	else:
		connect_to_server()
	print(get_tree().is_network_server())
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(BEN_IP, 60607)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("peer", peer)

func host_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(60607, 15)
	get_tree().set_network_peer(peer)
	get_tree().set_meta("peer", peer)
	
func _server_disconnected():
	print("Server disconnected.")
	connect_to_server()

func _connected_ok():
	print("Connected to server.")

func _connected_fail():
	print("Connection failed, retrying.")
	connect_to_server()

func _process(delta):
	timer += delta
	if timer >= 1.0:
		timer = 0
		ping()

func ping():
	rpc("pong")

remote func pong():
	print("keepalive")
