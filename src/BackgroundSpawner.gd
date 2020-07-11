extends Node2D

const background = preload("res://background-1.tscn")
const car = preload("res://Enemies/Car.tscn")

var nextBackground: int = -1
var numberOfCars: int = 0
var maxCars: int = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var backgrounda = background.instance()
	get_parent().add_child(backgrounda)
	backgrounda.global_position = Vector2(160, 90* nextBackground)
	nextBackground -= 1
	
	while(numberOfCars < maxCars):
		var carVal = car.instance()
		get_parent().add_child(carVal)
		carVal.global_position = Vector2(80, backgrounda.global_position.y + 90)
		numberOfCars += 1

	pass
