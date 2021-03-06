extends Node2D

const background = preload("res://background-2.tscn")
const car = preload("res://Enemies/Car.tscn")
const car2 = preload("res://Enemies/Car2.tscn")
const car3 = preload("res://Enemies/Car3.tscn")
const car4 = preload("res://Enemies/Car4.tscn")
const scooter = preload("res://Enemies/Scooter.tscn")
const deadScooter = preload("res://Enemies/DeadScooter.tscn")
const busStop = preload("res://Enemies/BusStop.tscn")

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
			backgrounda.global_position = Vector2(160, 90* nextBackground)
			nextBackground -= 1
			backgroundCount += 1
		else:
			backgrounds.pop_back().queue_free()
			backgroundCount -= 1
		
		if(numberOfCars < maxCars):
			var carVal
			randomize()
			var x = randi()%4
			if(x == 1):
				var y = randi()%4
				if(y == 1):
					carVal = car.instance()
				elif(y == 2):
					carVal = car2.instance()
				elif(y == 3):
					carVal = car3.instance()
				else:
					carVal = car4.instance()
				cars.push_front(carVal)
				get_parent().add_child(carVal)
				carVal.global_position = Vector2(80 + (randi()%160), 90* nextBackground)
			elif(x == 2):
				carVal = scooter.instance()
				cars.push_front(carVal)
				get_parent().add_child(carVal)
				carVal.global_position = Vector2(80 + (randi()%160), 90* nextBackground)
			elif(x == 3):
				carVal = busStop.instance()
				cars.push_front(carVal)
				get_parent().add_child(carVal)
				var y = randi()%2
				if(y == 1):
					carVal.global_position = Vector2(50, 90* nextBackground)
				else:
					carVal.global_position = Vector2(270, 90* nextBackground)
			else:
				carVal = deadScooter.instance()
				cars.push_front(carVal)
				get_parent().add_child(carVal)
				carVal.global_position = Vector2(80 + (randi()%160), 90* nextBackground)

#			carVal.global_position = Vector2(270, 90* nextBackground)
			numberOfCars += 1
		else:
			cars.pop_back().queue_free()
			numberOfCars -= 1
	pass
