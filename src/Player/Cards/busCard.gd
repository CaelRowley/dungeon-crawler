extends Area2D

export(String) var card = "BusCard" setget , getCard

func getCard():
	return card

var previous_mouse_position = Vector2()
var is_dragging = false

func _input(event):
	if not is_dragging:
		return
	if event.is_action_released("left_click"):
		previous_mouse_position = Vector2()
		is_dragging = false
	if is_dragging and event is InputEventMouseMotion:
		position += event.position - previous_mouse_position
		previous_mouse_position = event.position

func _on_Node2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		previous_mouse_position = event.position
		is_dragging = true
