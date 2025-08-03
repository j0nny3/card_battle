extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	BattleManager.end_turn()
