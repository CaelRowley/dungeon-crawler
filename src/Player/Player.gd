extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

var state = "Idle"
var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN
var stats = PlayerStats

var MAX_SPEED = 100
const ACCELERATION = 10000
const FRICTION = 50
const ROLL_SPEED = 110

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

onready var cardArea = $CardArea
onready var deck = $Deck

var timer = null
var canPlayCard = true
var speed = 1
var handSize = 0 
var cardsPlayed = 0
var score = 0

var slowTimer = null

var highestSpeed = 0
var startPos = 0
onready var hurtBox = $HitboxPivot/SwordHitbox/CollisionShape2D

var currentRole

func _ready():
	randomize()
	var x = randi()%3
	x=2
	if(x == 1):
		$BusSprite.visible = false
		$AmbulanceSprite.visible = true
		$PoliceSprite.visible = false
		currentRole = 'Ambulance'
	elif(x == 2):
		$BusSprite.visible = false
		$AmbulanceSprite.visible = false
		$PoliceSprite.visible = true
		currentRole = 'Police'
	else:
		$BusSprite.visible = true
		$AmbulanceSprite.visible = false
		$PoliceSprite.visible = false
		currentRole = 'Bus'
		
	hurtBox.disabled = true
	stats.connect("noHealth", self, "end_game")
	animationTree.active = true
	# sets default direction for sword attack to match roll direction
	swordHitbox.knockbackVector = rollVector
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.5)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	$Panel.visible = false
	
	slowTimer = Timer.new()
	slowTimer.set_one_shot(false)
	slowTimer.set_wait_time(1)
	slowTimer.connect("timeout", self, "on_timeout_slowdown")
	add_child(slowTimer)
	slowTimer.start()
	
	startPos = position.y


func end_game():
	state = "Win"
	hurtBox.disabled = false
	$BusSprite.visible = false
	$AmbulanceSprite.visible = false
	$PoliceSprite.visible = false
	$Panel/MaxSpeed.text = 'Max Speed: ' + str(highestSpeed)
	$Panel/Distance.text = 'Distance: ' + str(-position.y - -startPos)
	$Panel/Score.text = 'Score: ' + str(score)
	$Panel.visible = true
	canPlayCard = false

	
func _unhandled_input(event):
	if event.is_action_released("left_click") && canPlayCard:
		for area in cardArea.get_overlapping_areas():
			if(MAX_SPEED > highestSpeed):
				highestSpeed = MAX_SPEED
			if(area.getCard() != "DeckCard"):
				MAX_SPEED+=20			
				handSize -= 1
				cardsPlayed +=1
				$Panel/CardsPlayed.text = 'Cards Played: ' + str(cardsPlayed)
				
			if(area.getCard() == "KillCard"):
				timer.start()
				hurtBox.disabled = false
				area.queue_free()
			elif(area.getCard() == "DeckCard"):
				area.queue_free()
				deck.newDeck()
			elif(area.getCard() == "AmbulanceCard"):
				hurtbox.createHitEffect()
				$BusSprite.visible = false
				$AmbulanceSprite.visible = true
				$PoliceSprite.visible = false
				currentRole = 'Ambulance'
				area.queue_free()
			elif(area.getCard() == "PoliceCard"):
				hurtbox.createHitEffect()
				$BusSprite.visible = false
				$AmbulanceSprite.visible = false
				$PoliceSprite.visible = true
				currentRole = 'Police'
				area.queue_free()
			elif(area.getCard() == "BusCard"):
				hurtbox.createHitEffect()
				$BusSprite.visible = true
				$AmbulanceSprite.visible = false
				$PoliceSprite.visible = false
				currentRole = 'Bus'
				area.queue_free()
			else:
				state = area.getCard()
				area.queue_free()

func _process(delta):
	match state:
		"Idle":
			idleState(delta)
		"LeftCard":
			leftState(delta)
		"RightCard":
			rightState(delta)
		"BoostCard":
			boostState(delta)
		"Win":
			velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
			canPlayCard = false
	velocity = move_and_slide(velocity)
	if(handSize < 1):
		deck.discardHand()
		deck.nextHand()
		handSize = deck.getHandSize()

func on_timeout_complete():
	if (state != "Win"):
		hurtBox.disabled = true
		canPlayCard = true
		state = "Idle"
	
func on_timeout_slowdown():
	pass
	if(MAX_SPEED >= 20):
		MAX_SPEED -= 10
	
func leftState(delta):
	if(canPlayCard):
		canPlayCard = false
		timer.start()
	var targetVector = Vector2.ZERO
	targetVector.x = -1
	targetVector.y = -1
	var targetPosition = global_position + targetVector.normalized()
	drift(targetPosition, delta, MAX_SPEED)

func rightState(delta):
	if(canPlayCard):
		canPlayCard = false
		timer.start()
	var targetVector = Vector2.ZERO
	targetVector.x = 1
	targetVector.y = -1
	var targetPosition = global_position + targetVector.normalized()
	drift(targetPosition, delta, MAX_SPEED)

func boostState(delta):
	if(canPlayCard):
		canPlayCard = false
		timer.start()
	var targetVector = Vector2.ZERO
	targetVector.x = 0
	targetVector.y = -1
	var targetPosition = global_position + targetVector.normalized()
	MAX_SPEED += 1
	

func drive(targetPosition, delta):
	var direction = global_position.direction_to(targetPosition)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func drift(targetPosition, delta, maxSpeed):
	var direction = global_position.direction_to(targetPosition)
	velocity = velocity.move_toward(direction * maxSpeed, ACCELERATION * delta)
	
func idleState(delta):
	var targetVector = Vector2.ZERO
	targetVector.y = -1
	var targetPosition = global_position + targetVector
	drive(targetPosition, delta)
	
	
	
	
	
	
	
func runState(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		swordHitbox.knockbackVector = inputVector
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Roll/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("attack"):
		state = "attack"
		
	if Input.is_action_just_pressed("dodge"):
		state = "dodge"
	
func attackState():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attackStateFinished():
	state = "run"

func dodgeState():
	velocity = move_and_slide(rollVector * ROLL_SPEED)
	animationState.travel("Roll")

func dodgeStateFinished():
	velocity = velocity * 0.9
	state = "run"

func _on_Hurtbox_area_entered(collider):
	if (collider.getName() == 'Scooter' && currentRole == 'Police'):
		score += 10
		hurtbox.createScoreEffect()
	elif (collider.getName() == 'DeadScooter' && currentRole == 'Ambulance'):
		score += 10
		hurtbox.createScoreEffect()
	elif (collider.getName() == 'BusStop' && currentRole == 'Bus'):
		score += 10
		hurtbox.createScoreEffect()
	else:
		hurtbox.startInvincibility(1)
		hurtbox.createHitEffect()
		blinkAnimationPlayer.play("Start")
		stats.setHealth(stats.getHealth() - collider.getDamage())
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound)
	
func _on_MenuButton_pressed():
	stats.setHealth(3)
	get_tree().change_scene("res://World.tscn")
