extends Control

signal mode_chosen

func _ready():
	$OfflineButton.pressed.connect(_on_offline_pressed)
	$JoinOptions/JoinButton.pressed.connect(_on_join_pressed)
	$HostButton.pressed.connect(_on_host_pressed)

func _on_offline_pressed():
	mode_chosen.emit("offline")

func _on_join_pressed():
	mode_chosen.emit("join")

func _on_host_pressed():
	mode_chosen.emit("host")
