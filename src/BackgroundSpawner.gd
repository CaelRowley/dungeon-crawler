extends Node2D

const background = preload("res://background-1.tscn")
const car = preload("res://Enemies/Car.tscn")

var backgrounds: Array = []
var numOfBackgrounds: int = 1000
var nextBackground: int = -1
var backgroundCount: int = 0

var cars: Array = []
var maxCars: int = 1000
var numberOfCars: int = 0

var time_passed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if(floor(time_passed) / 10.0 == 0):
		if(backgroundCount < numOfBackgrounds):
			var backgrounda = background.instance()
			backgrounds.push_front(backgrounda)
			get_parent().add_child(backgrounda)
			backgrounda.global_position = Vector2(160, 90* nextBackground)
			nextBackground -= 1
			backgroundCount += 1
		else:
			backgrounds.pop_back().queue_free()
			backgroundCount -= 1
		
		if(numberOfCars < maxCars):
			var carVal = car.instance()
			cars.push_front(carVal)
			get_parent().add_child(carVal)
			carVal.global_position = Vector2(35* (randi()%8)+1, 90* nextBackground)
			numberOfCars += 1
		else:
			cars.pop_back().queue_free()
			numberOfCars -= 1

	pass
