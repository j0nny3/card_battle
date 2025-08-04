extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if multiplayer.has_multiplayer_peer():
		BattleManager.request_end_turn.rpc_id(1)
