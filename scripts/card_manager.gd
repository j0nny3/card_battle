extends Node

signal drawn

var card_db = {}

var instance_id= 0

var effects = {
	"none": func(user, target, n, m): return,
	"strike": func(user, target, n, m): target.take_damage(n),
	"heal": func(user, target, n, m): user.heal(n),
	"block": func(user, target, n, m): return,
	"stab": func(user, target, n, m): user.take_damage_range(n,m),
	"draw": func (user,target, n,  m): CardManager.draw(user, n),
}

func get_effect(id: String) -> Callable:
	return effects.get(id)

func _ready():
	load_card_database()

@rpc("reliable", "authority")
func load_card_database():
	var file = FileAccess.open("res://cards/cards.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)

	for entry in parsed:
		var card = Card.new()
		card.id = entry.get("id", "")
		card.name = entry.get("name", "")
		card.cost = entry.get("cost", 0)
		card.description = entry.get("description", "")
		card.effect = effects.get(entry.get("effect", "none"))
		card.number= entry.get("number",0)
		card.number2= entry.get("number2",0)
		card.blockable= entry.get("blockable", false)
		card.blocks= entry.get("blocks", false)
		card_db[card.id] = card

func load_deck(player):
	for count in 40:
		var card_id = card_db.keys().pick_random()
		var card = card_db[card_id]
		var card_duplicate = card.duplicate()
		instance_id+=1
		card_duplicate.instance_id= instance_id
		player.deck.cards.append(card_duplicate) 
	player.deck.cards.shuffle()

func draw(player, n=1):
	var drawn_cards = player.deck.cards.slice(0, n)
	player.hand.append_array(drawn_cards)
	player.deck.cards = player.deck.cards.slice(n)

func get_card_by_instance_id(id):
	for player in BattleManager.player_dict :
		for card in player.hand:
			if card.instance_id == id:
				return card
	return null
