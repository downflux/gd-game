class_name DFPlayerVerification
extends Node
## Defines how to initialize and track an incoming player connection
## request.

@onready var player_scene: PackedScene = preload("res://scenes/instances/player/player.tscn")


var _DEBUG_PLAYER_CREDENTIALS = {  # { mint: String -> Dictionary }
	"0xPIZZA": {
		DFStateKeys.KDFPlayerUsername:           "Panucci",
		DFServerStateKeys.KDFPlayerID:           "abcd-ef-ghij",
		DFServerStateKeys.KDFPlayerStreamerMode: true,
		DFStateKeys.KDFPlayerFaction:            DFEnums.Faction.FACTION_ALPHA,
	},
	"0xPUB": {
		DFStateKeys.KDFPlayerUsername:           "O'ZORGNAX",
		DFServerStateKeys.KDFPlayerID:           "zyxw-vu-tsrq",
		DFServerStateKeys.KDFPlayerStreamerMode: false,
		DFStateKeys.KDFPlayerFaction:            DFEnums.Faction.FACTION_BETA,
	},
}


## Verifies that the incoming client has a valid token. This token is generated
## by the authentication server earlier in the handshake and passed along to
## the game server.
## [br][br]
## The incoming player connection request does not contain any stored
## credentials; the request instead contains a token generated by the
## authentication server.
## [br][br]
## Returns a valid [DFPlayer] object if the [param token] is valid, or
## [code]null[/code] if it is not.
## [br][br]
## TODO(minkezhang): Implement authentication server.
func verify(sid: int, token: String = "0xPIZZA") -> DFServerPlayer:
	if token not in _DEBUG_PLAYER_CREDENTIALS:
		return null
	
	var p: DFServerPlayer = player_scene.instantiate()
	p.name = str(sid)
	add_child(p, true)
	
	p.session_id = sid
	p.player_id = _DEBUG_PLAYER_CREDENTIALS[token][DFServerStateKeys.KDFPlayerID]
	p.streamer_mode = _DEBUG_PLAYER_CREDENTIALS[token][DFServerStateKeys.KDFPlayerStreamerMode]
	p.player_state.username = _DEBUG_PLAYER_CREDENTIALS[token][DFStateKeys.KDFPlayerUsername]
	p.player_state.faction = _DEBUG_PLAYER_CREDENTIALS[token][DFStateKeys.KDFPlayerFaction]
	
	return p
