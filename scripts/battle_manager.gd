extends Node

signal card_played

var player1 = Player.new(Player.Type.HUMAN)
var player2 = Player.new(Player.Type.NPC)
var players = [player1, player2]
var current_player = player1
var not_current_player = player2

func end_turn():
	simulate_enemy_card()

	await get_tree().create_timer(3.0).timeout

	resolve_cards()
	get_turn_end_ressources()

func get_turn_end_ressources():
	for player in players:
		player.current_mana=player.current_mana+1
		CardManager.draw(player)

func play_card(player, card):
	if player.current_mana < card.cost :
		return
	player.current_mana-=card.cost
	player.active_cards.append(card)
	card.played.emit()
	card_played.emit(card, player == player1)

func simulate_enemy_card():
	var card = player2.hand.pick_random()
	play_card(player2, card)

func resolve_cards():
	for card in player1.active_cards:
		resolve_card(card,player1,player2)
		card.used.emit()
	for card in player2.active_cards:
		resolve_card(card,player2,player1)
		card.used.emit()
	for player in players:
		player.active_cards.clear()

func resolve_card(card, own_player, opposing_player):
	if card.blockable and opposing_player.active_card.any(func(_card): card.blocks):
		return
	card.effect.call(own_player,opposing_player, card.number, card.number2)
