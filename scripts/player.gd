class_name Player 
extends Node

signal health_changed
signal mana_changed

enum Type{HUMAN, NPC}

var health: int = 10
var armour: int = 0
var max_health: int = 10
var current_mana: int = 3:
	set(new_value):
		current_mana = new_value
		mana_changed.emit(current_mana, max_mana)
var max_mana= 10

var hand = []
var deck = Deck.new()
var active_cards: Array[Card]

var type: Type

func _init(_type):
	type = _type

func take_damage(number):
	health-=number
	health_changed.emit(health, max_health)
	if health <= 0:
		die()

func heal(number):
	health+=number

func die():
	print("dead")
