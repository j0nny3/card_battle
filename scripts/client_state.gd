extends Node

signal health_changed
signal max_health_changed
signal enemy_health_changed
signal enemy_max_health_changed
signal mana_changed
signal enemy_mana_changed
signal hand_changed
signal active_cards_changed
signal enemy_active_cards_changed

var username: String
var health: int = 10:
	set(new_value):
		health = new_value
		health_changed.emit(health, max_health)
var max_health: int = 10:
	set(new_value):
		max_health = new_value
		max_health_changed.emit(max_health)

var armour: int = 0
var mana: int = 3: 
	set(new_value):
		mana = new_value
		mana_changed.emit(mana, max_mana)
var max_mana= 10
var hand: Array[Card]:
	set(new_value):
		print("set hand")
		hand = new_value
		hand_changed.emit(hand)
var active_cards: Array[Card]:
	set(new_value):
		active_cards = new_value
		active_cards_changed.emit(active_cards)

var enemy_active_cards: Array[Card]:
	set(new_value):
		enemy_active_cards = new_value
		enemy_active_cards_changed.emit(enemy_active_cards)

var turn_ended= false

var enemy_health = 10:
	set(new_value):
		enemy_health = new_value
		enemy_health_changed.emit(enemy_health, max_health)
var enemy_mana = 10:
	set(new_value):
		enemy_mana = new_value
		enemy_mana_changed.emit(enemy_mana, max_mana)
var enemy_max_mana = 10
var enemy_max_health = 10:
	set(new_value):
		enemy_health = new_value
		enemy_max_health_changed.emit(max_health)

@rpc("reliable", "any_peer","call_remote")
func reveal(data: Dictionary):
	var enemy_active_ids=data.get("enemy_active_cards", [])
	var new_enemy_active: Array[Card]
	for id in enemy_active_ids:
		new_enemy_active.append(CardManager.card_db.get(id))
	enemy_active_cards = new_enemy_active


@rpc("reliable", "any_peer","call_remote")
func sync(data: Dictionary):
	health=data.get("health")
	enemy_health=data.get("enemy_health", 10)
	mana=data.get("mana")
	enemy_mana=data.get("enemy_mana", 3)

	var hand_ids=data.get("hand")
	var new_hand : Array[Card]
	for id in hand_ids:
		new_hand.append(CardManager.card_db.get(id))
	hand = new_hand

	var active_ids=data.get("active_cards")
	var new_active : Array[Card]
	for id in active_ids:
		new_active.append(CardManager.card_db.get(id))
	active_cards = new_active

	var enemy_active_ids=data.get("enemy_active_cards", [])
	var new_enemy_active: Array[Card]
	for id in enemy_active_ids:
		new_enemy_active.append(CardManager.card_db.get(id))
	enemy_active_cards = new_enemy_active
