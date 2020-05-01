extends KinematicBody2D

const FRICTION = 200

onready var stats = $Stats

var knockback = Vector2.ZERO
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
func _on_Hurtbox_area_entered(area):
	stats.setHealth(stats.getHealth() - 1)
	knockback = area.knockbackVector * 120

func _on_Stats_noHealth():
	queue_free()
