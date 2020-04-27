extends KinematicBody2D

enum {
	RUN,
	DODGE,
	ATTACK
}
var state = RUN
var velocity = Vector2.ZERO

const MAX_SPEED = 100
const ACCELERATION = 400
const FRICTION = 400

# onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	
# _function <== means callback function
func _physics_process(delta):
	match state:
		RUN:
			runState(delta)
		ATTACK:
			attackState(delta)
		DODGE:
			pass

func runState(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("dodge"):
		state = DODGE
	
func attackState(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attackStateFinished():
	state = RUN
