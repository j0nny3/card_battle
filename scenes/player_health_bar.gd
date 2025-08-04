extends ProgressBar

@onready var label = $Label

func _ready():
	value = ClientState.health
	max_value = value
	ClientState.health_changed.connect(_on_player_health_changed)
	label.text= str(value) + " / " + str(max_value)

func _on_player_health_changed(current_health, max_health):
	value=current_health
	max_value=max_health
	label.text = str(current_health) + " / " + str(max_health)
