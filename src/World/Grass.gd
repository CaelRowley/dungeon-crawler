extends Node2D

var GrassAnimation = load("res://Effects/GrassAnimation.tscn")

func createGrassEffect():
	var grassAnimation = GrassAnimation.instance()
	var world = get_tree().current_scene
	world.add_child(grassAnimation)
	grassAnimation.global_position = global_position
	queue_free()


func _on_Hurtbox_area_entered(area):
	createGrassEffect()
