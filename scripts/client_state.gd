extends Node

signal health_changed
signal enemy_health_changed

var username: String
var health: int = 10:
	set(new_value):
		health = new_value
		health_changed.emit(health, max_health)
var armour: int = 0
var max_health: int = 10
var current_mana: int = 3
var max_mana= 10
var hand = []
var active_cards: Array[Card]
var turn_ended= false

var enemy_health:
	set(new_value):
		enemy_health = new_value
		enemy_health_changed.emit(enemy_health, max_health)
var enemy_mana
