extends KinematicBody2D

var velocity = Vector2.ZERO

const MAX_SPEED = 200
const ACCELERATION = 10
const FRICTION = 25

# _function <== means callback function
func _physics_process(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if inputVector != Vector2.ZERO:
		velocity += inputVector.normalized() * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_collide(velocity)
