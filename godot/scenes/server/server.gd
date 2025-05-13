extends Node
class_name DFServer

@export var PORT: int = 7777

@onready
var mp: MultiplayerAPI = MultiplayerAPI.create_default_interface()

const _MAX_CLIENTS = 2

func _on_peer_connected(id: int):
	print('client connected: ', id)
	print(mp.get_peers())
	get_tree().set_multiplayer(mp)
	get_parent().get_node("Client").set_server_offset.rpc_id(id, Time.get_unix_time_from_system())

func _on_peer_disconnected(id: int):
	print('client disconnected: ', id)

func start(port: int, max_clients: int):
	var _p = ENetMultiplayerPeer.new()
	_p.create_server(port, max_clients)
	
	mp.multiplayer_peer = _p

func stop():
	mp.multiplayer_peer = null

func _ready():
	mp.peer_connected.connect(_on_peer_connected)
	mp.peer_disconnected.connect(_on_peer_disconnected)
	
	get_tree().set_multiplayer(mp, "/Main/Server")
	
	start(PORT, _MAX_CLIENTS)
