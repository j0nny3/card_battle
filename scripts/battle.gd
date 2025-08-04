extends Node

@onready var hand_ui = $%HandUI

func _ready():
	NetworkManager.player_loaded.rpc_id(1)

	BattleManager.card_played.connect(_on_card_played)
	ClientState.hand_changed.connect(_on_hand_changed)

func _on_hand_changed(cards):
	hand_ui.update_cards(cards)

func _on_card_played(card, is_player):
	var slot
	if is_player:
		slot = $%ActiveAreaPlayerUI
	else:
		slot = $%ActiveAreaEnemyUI
	var card_scene = preload("res://scenes/card.tscn")
	var card_instance = card_scene.instantiate()
	slot.add_child(card_instance)
	card_instance.set_card(card)
	card_instance.is_in_hand=false
