extends Node2D

const background = preload("res://background-1.tscn")

var nextBackground: int = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var backgrounda = background.instance()
	get_parent().add_child(backgrounda)
	backgrounda.global_position = Vector2(160, 90* nextBackground)
	nextBackground -= 1

	pass
