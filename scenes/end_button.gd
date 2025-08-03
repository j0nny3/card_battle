extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if multiplayer.has_multiplayer_peer():
		BattleManager.end_turn.rpc()
	else:
		BattleManager.end_turn()
