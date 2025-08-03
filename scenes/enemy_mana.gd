extends ProgressBar

func _ready():
	value = BattleManager.player2.current_mana
	max_value = BattleManager.player2.max_mana
	BattleManager.player2.mana_changed.connect(_on_player_mana_changed)

func _on_player_mana_changed(current_mana, max_mana):
	value = current_mana
	max_value = max_mana
