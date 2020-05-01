extends Node

export(int) var maxHealth = 1
# onready needed to load variables modified by the Inspector tool
onready var health = maxHealth setget setHealth, getHealth

func setHealth(newHealth):
	health = newHealth 
	if health <= 0:
		emit_signal("noHealth")

func getHealth():
	return health

signal noHealth
