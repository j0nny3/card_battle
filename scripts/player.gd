class_name Player 
extends Node

signal health_changed
signal mana_changed

enum Type{HUMAN, NPC}

var id: int
var username: String
var health: int = 10
var armour: int = 0
var max_health: int = 10
var mana: int = 3:
	set(new_value):
		mana = new_value
		mana_changed.emit(mana, max_mana)
var max_mana= 10

var hand = []
# server
var deck = Deck.new()
var active_cards: Array[Card]

var type: Type
var turn_ended= false

func _init(_type):
	type = _type

func take_damage(number):
	health-=number
	health_changed.emit(health, max_health)
	if health <= 0:
		die()

func take_damage_range(min, max):
	health-=randi_range(min, max)
	health_changed.emit(health, max_health)
	if health <= 0:
		die()
func heal(number):
	health+=number

func die():
	print("dead")
