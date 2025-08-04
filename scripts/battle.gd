extends Node

@onready var hand_ui = $%HandUI

func _ready():
	NetworkManager.player_loaded.rpc_id(1)
	BattleManager.card_played.connect(_on_card_played)
	CardManager.drawn.connect(_on_player_draw)

	CardManager.draw(BattleManager.player1, 5)
	CardManager.draw(BattleManager.player2, 5)

func _on_player_draw(player, cards):
	if player.type == player.Type.HUMAN:
		for card in cards:
			var card_scene = preload("res://scenes/card.tscn")
			var card_instance = card_scene.instantiate()
			hand_ui.add_child(card_instance)
			card_instance.set_card(card)

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
