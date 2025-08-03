extends Panel

var card: Card
var is_in_hand = true

@onready var name_label = $VBoxContainer/NameLabel
@onready var cost_label = $VBoxContainer/CostLabel
@onready var description_label = $VBoxContainer/DescriptionLabel

func set_card(_card: Card):
	card = _card
	update_ui()
	card.played.connect(_on_card_played)
	card.used.connect(_on_card_used)

func update_ui():
	name_label.text = card.name
	cost_label.text = "Cost: %d" % card.cost
	description_label.text = card.description

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked cardUI")
		if multiplayer.has_multiplayer_peer():
			BattleManager.play_card.rpc(BattleManager.player1, card.instance_id)
		else:
			BattleManager.play_card(BattleManager.player1, card)
	
func _on_card_played():
	if is_in_hand:
		queue_free()

func _on_card_used():
	if not is_in_hand:
		queue_free()
