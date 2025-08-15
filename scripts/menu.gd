extends Control

signal mode_chosen
signal official_chosen(username: String)
signal connect_requested(address: String, username)

@onready var official_name_edit = $OfficialJoinOptions/OfficialPlayerName

func _ready():
	$JoinOptions/JoinButton.pressed.connect(_on_join_pressed)
	$OfficialJoinOptions/OfficialJoinButton.pressed.connect(_on_official_join_pressed)
	$HostButton.pressed.connect(_on_host_pressed)

func _on_offline_pressed():
	mode_chosen.emit("offline")

func _on_join_pressed():
	var address = $JoinOptions/AddressEdit.text
	var username = $JoinOptions/UsernameEdit.text
	connect_requested.emit(address, username)

func _on_host_pressed():
	mode_chosen.emit("host")

func _on_official_join_pressed():
	official_chosen.emit(official_name_edit.text)
