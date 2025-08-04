extends Node

@onready var hand_ui = $%HandUI
@onready var active_area_slot = $%ActiveAreaPlayerUI
@onready var enemy_active_area_slot = $%ActiveAreaEnemyUI

func _ready():
	hand_ui.update_cards(ClientState.hand)
	NetworkManager.player_loaded.rpc_id(1)
	ClientState.hand_changed.connect(_on_hand_changed)
	ClientState.active_cards_changed.connect(_on_active_cards_changed)
	ClientState.enemy_active_cards_changed.connect(_on_enemy_active_cards_changed)

func _on_hand_changed(cards):
	hand_ui.update_cards(cards)


func _on_active_cards_changed(cards: Array[Card]):
	for child in active_area_slot.get_children():
		child.queue_free()
	for card in cards:
		var card_scene = preload("res://scenes/card.tscn")
		var card_instance = card_scene.instantiate()
		active_area_slot.add_child(card_instance)
		card_instance.set_card(card)
		card_instance.is_in_hand=false

func _on_enemy_active_cards_changed(cards: Array[Card]):
	for child in enemy_active_area_slot.get_children():
		child.queue_free()
	for card in cards:
		var card_scene = preload("res://scenes/card.tscn")
		var card_instance = card_scene.instantiate()
		enemy_active_area_slot.add_child(card_instance)
		card_instance.set_card(card)
		card_instance.is_in_hand=false
