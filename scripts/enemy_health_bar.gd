extends ProgressBar

@onready var label = $Label

func _ready():
	ClientState.enemy_health_changed.connect(_on_enemy_health_changed)
	min_value = 0
	value = ClientState.enemy_health
	max_value = ClientState.enemy_max_health
	label.text = str(value) + " / " + str(max_value)

func _on_enemy_health_changed(current_health, max_health):
	value=current_health
	max_value=max_health
	label.text = str(current_health) + " / " + str(max_health)

