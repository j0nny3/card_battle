extends HBoxContainer

func update_cards(cards: Array[Card]):
	print("update hand")
	for child in get_children():
		child.queue_free()
	for card in cards:
		var card_scene = preload("res://scenes/card.tscn")
		var card_instance = card_scene.instantiate()
		add_child(card_instance)
		card_instance.set_card(card)
