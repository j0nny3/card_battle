class_name Card
extends Resource

signal played
signal used


@export var id: String
@export var instance_id: int
@export var name: String
@export var cost: int
@export var description: String
@export var effect: Callable
@export var number: int
@export var number2: int
@export var blockable: bool
@export var blocks: bool
@export var risky: bool

func print_info():
	print(id + name + str(cost) + description )
	print("effect"+ str(effect))
