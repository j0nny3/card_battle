extends Node

@onready var hand_ui = $%HandUI

func _ready():
	BattleManager.card_played.connect(_on_card_played)

	CardManager.load_decks()
	CardManager.draw(BattleManager.player1)
	CardManager.draw(BattleManager.player2)
	display_hand()

func display_hand():
	for card in BattleManager.player1.hand:
		var card_scene = preload("res://scenes/card.tscn")
		var card_instance = card_scene.instantiate()
		hand_ui.add_child(card_instance)
		card_instance.set_card(card)

func _on_card_played(card, is_player):
	var slot
	if is_player:
		slot = $%ActiveAreaPlayerUi
	else:
		slot = $%ActiveAreaEnemyUi
	var card_scene = preload("res://scenes/card.tscn")
	var card_instance = card_scene.instantiate()
	slot.add_child(card_instance)
	card_instance.set_card(card)
	card_instance.is_in_hand=false
