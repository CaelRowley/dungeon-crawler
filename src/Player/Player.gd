extends KinematicBody2D

var velocity = Vector2.ZERO

const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

onready var animationPlayer = $AnimationPlayer

# _function <== means callback function
func _physics_process(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if inputVector != Vector2.ZERO:
		if(inputVector.x > 0):
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		if(inputVector.x > 0):
			animationPlayer.play("IdleRight")
		else:
			animationPlayer.play("IdleLeft")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
