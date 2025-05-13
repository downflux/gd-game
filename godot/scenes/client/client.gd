extends Node
class_name DFClient

@export var ADDRESS: String = "127.0.0.1"
@export var PORT: int = 7777

var _offset: float

@onready
var mp: MultiplayerAPI = MultiplayerAPI.create_default_interface()

func _on_connected_to_server():
	print('connected to server: %s:%s' % [ADDRESS, PORT])
	
func _on_connection_failed():
	print('server connection failed')

func _on_server_disconnected():
	print('disconnected from server')

func start(ip: String, port: int):
	var _p = ENetMultiplayerPeer.new()
	_p.create_client(ip, port)
	
	mp.multiplayer_peer = _p

func stop():
	mp.multiplayer_peer = null

@rpc("authority", "call_local", "reliable")
func set_server_offset(timestamp: float):
	await get_tree().create_timer(2).timeout
	
	_offset = Time.get_unix_time_from_system() - timestamp
	print("sender = ", mp.get_remote_sender_id())
	print("self = ", mp.get_unique_id())
	print(_offset)

func _ready():
	mp.connected_to_server.connect(_on_connected_to_server)
	mp.connection_failed.connect(_on_connection_failed)
	mp.server_disconnected.connect(_on_server_disconnected)
	
	get_tree().set_multiplayer(mp, "/Main/Client")
	
	start(ADDRESS, PORT)
