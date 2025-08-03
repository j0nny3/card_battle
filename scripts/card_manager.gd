extends Node

var card_db = {}

var effects = {
	"none": func(user, target, n): return,
	"strike": func(user, target, n): target.take_damage(n),
	"heal": func(user, target, n): user.heal(n),
	"block": func(user, target, n): user.block(n),
	"stab": func(user, target, n): user.heal(n),
	"draw": func (user,target, n): CardManager.draw(user, n),
}

func get_effect(id: String) -> Callable:
	return effects.get(id)

func _ready():
	load_card_database()

func load_card_database():
	var file = FileAccess.open("res://cards/cards.json", FileAccess.READ)
	var text = file.get_as_text()
	var parsed = JSON.parse_string(text)

	for entry in parsed:
		var card = Card.new()
		card.id = entry.get("id", "")
		card.name = entry.get("name", "")
		card.cost = entry.get("cost", 0)
		card.description = entry.get("description", "")
		card.effect = get_effect(entry.get("effect", "none"))
		card.number= entry.get("number")
		card.blockable= entry.get("blockable", false)
		card.blocks= entry.get("blocks", false)
		card_db[card.id] = card

func get_card(id: String) -> Card:
	return card_db.get(id, null)

func load_decks():
	for player in BattleManager.players:

		print("Card DB contents:")
		for k in CardManager.card_db.keys():
			print("- ", k)
		
		for count in 40:
			var card_id = card_db.keys().pick_random()
			var card = card_db[card_id]
			player.deck.cards.append(card.duplicate()) 
		player.deck.cards.shuffle()
			
func draw(player, n=1):
	var drawn = player.deck.cards.slice(0, n)
	player.hand.append_array(drawn)
	player.deck.cards = player.deck.cards.slice(n)
