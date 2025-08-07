extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var address = get_parent().get_node("AddresEdit").text
	var username
	username = get_parent().get_node("NameEdit").text
	if not username :
		username =get_parent().get_node("NameEdit").placeholder_text 
	NetworkManager.player_info["name"] = username
	var error =NetworkManager.join_server(address)
	if error:
		print(error)
