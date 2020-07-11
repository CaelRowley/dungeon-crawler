extends Node2D

const background = preload("res://background-1.tscn")
const car = preload("res://Enemies/Car.tscn")
const scooter = preload("res://Enemies/Scooter.tscn")
const deadScooter = preload("res://Enemies/DeadScooter.tscn")

var backgrounds: Array = []
var numOfBackgrounds: int = 500
var nextBackground: int = -1
var backgroundCount: int = 0

var cars: Array = []
var maxCars: int = 500
var numberOfCars: int = 0

var time_passed = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if(int(time_passed) % 20 == 0):
		if(backgroundCount < numOfBackgrounds):
			var backgrounda = background.instance()
			backgrounds.push_front(backgrounda)
			get_parent().add_child(backgrounda)
			backgrounda.global_position = Vector2(160, 240* nextBackground)
			nextBackground -= 1
			backgroundCount += 1
		else:
			backgrounds.pop_back().queue_free()
			backgroundCount -= 1
		
		if(numberOfCars < maxCars):
			var carVal
			randomize()
			var x = randi()%3
			if(x == 1):
				carVal = car.instance()
			elif(x == 2):
				carVal = scooter.instance()
			else:
				carVal = deadScooter.instance()

			cars.push_front(carVal)
			get_parent().add_child(carVal)
			carVal.global_position = Vector2(35* (randi()%8)+1, 90* nextBackground)
			numberOfCars += 1
		else:
			cars.pop_back().queue_free()
			numberOfCars -= 1
	pass
