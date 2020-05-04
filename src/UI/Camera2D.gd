extends Camera2D

const SMOOTHING_DURATION: = 0.2

onready var target: Node2D = get_node("../YSort/Player")

var current_position
var destination_position

func _ready():
	current_position = position

func _process(delta: float):
	destination_position = target.position
	current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
	
	position = current_position.round()
	force_update_scroll()
