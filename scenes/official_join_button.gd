extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var address = "cardbattle.duckdns.org"
	var username: String
	username = get_parent().get_node("OfficialPlayerName").text
	if not username:
		username = "Player"

	NetworkManager.player_info["name"] = username
	NetworkManager.join_server(address)
