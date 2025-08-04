extends ProgressBar

func _ready():
	value = ClientState.enemy_mana
	max_value = ClientState.enemy_max_mana
	ClientState.enemy_mana_changed.connect(_on_enemy_mana_changed)
	$Label.text= str(value) + " / " + str(max_value)

func _on_enemy_mana_changed(current_mana, max_mana):
	value = current_mana
	max_value = max_mana
	$Label.text= str(value) + " / " + str(max_value)
