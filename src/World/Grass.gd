extends Node2D

var GrassAnimation = load("res://Effects/GrassAnimation.tscn")

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grassAnimation = GrassAnimation.instance()
		var world = get_tree().current_scene
		world.add_child(grassAnimation)
		grassAnimation.global_position = global_position
		queue_free()
