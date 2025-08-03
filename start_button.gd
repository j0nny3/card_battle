extends Button

var battle_scene_string = "res://scenes/battle.tscn"

func _ready():
	pressed.connect(_on_button_pressed)
	NetworkManager.player_connected.connect(_on_player_connected)

func _on_button_pressed():
	NetworkManager.load_game.rpc(battle_scene_string)

func _on_player_connected(peer_id, player_info):
	print(NetworkManager.players)
	if NetworkManager.players.keys().size()==3:
		NetworkManager.load_game.rpc(battle_scene_string)
