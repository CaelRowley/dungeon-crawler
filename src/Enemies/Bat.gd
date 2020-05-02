extends KinematicBody2D

const BatEffect = preload("res://Effects/BatEffect.tscn")

const FRICTION = 200

onready var stats = $Stats

var knockback = Vector2.ZERO
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
func _on_Hurtbox_area_entered(collider):
	stats.setHealth(stats.getHealth() - collider.getDamage())
	knockback = collider.knockbackVector * 120

func _on_Stats_noHealth():
	var batEffect = BatEffect.instance()
	get_parent().add_child(batEffect)
	batEffect.global_position = global_position
	queue_free()
