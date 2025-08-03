extends ProgressBar

@onready var label = $Label

func _ready():
	min_value=0
	value=BattleManager.player2.health
	max_value=BattleManager.player2.health
	BattleManager.player2.health_changed.connect(_on_enemy_health_changed)
	label.text= str(value) + " / " + str(max_value)

func _on_enemy_health_changed(current_health, max_health):
	value=current_health
	max_value=max_health
	label.text = str(current_health) + " / " + str(max_health)

