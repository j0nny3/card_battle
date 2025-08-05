extends Control

signal mode_chosen

@onready var official_name_edit = $OfficialJoinOptions/OfficialPlayerName

func _ready():
	$OfflineButton.pressed.connect(_on_offline_pressed)
	$JoinOptions/JoinButton.pressed.connect(_on_join_pressed)
	$OfficialJoinOptions/OfficialJoinButton.pressed.connect(_on_official_join_pressed)
	$HostButton.pressed.connect(_on_host_pressed)

func _on_offline_pressed():
	mode_chosen.emit("offline")

func _on_join_pressed():
	mode_chosen.emit("join")

func _on_host_pressed():
	mode_chosen.emit("host")

func _on_official_join_pressed():
	mode_chosen.emit("official")
	var address = "cardbattle.duckdns.org"
	var username: String
	username = official_name_edit.text
	if not username:
		username = "Player"

	NetworkManager.player_info["username"] = username
	NetworkManager.join_game(address)
