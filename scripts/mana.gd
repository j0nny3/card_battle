extends ProgressBar

@onready var label =$Label

func _ready():
	value = ClientState.mana
	max_value = ClientState.max_mana
	ClientState.mana_changed.connect(_on_player_mana_changed)
	label.text= str(value) + " / " + str(max_value)

func _on_player_mana_changed(current_mana, max_mana):
	value = current_mana
	max_value = max_mana
	label.text= str(current_mana) + " / " + str(max_mana)
