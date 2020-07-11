extends Area2D

onready var player = $Player

func _unhandled_input(event):
	if event.is_action_released("left_click"):
		for area in get_overlapping_areas():
			var card = area.getCard()
			print(card)
			area.queue_free()
