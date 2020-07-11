extends Node

const leftCard = preload("res://Player/Cards/LeftCard.tscn")
const rightCard = preload("res://Player/Cards/RightCard.tscn")
const boostCard = preload("res://Player/Cards/BoostCard.tscn")
const killCard = preload("res://Player/Cards/KillCard.tscn")
const policeCard = preload("res://Player/Cards/policeCard.tscn")
const ambulanceCard = preload("res://Player/Cards/ambulanceCard.tscn")
const busCard = preload("res://Player/Cards/busCard.tscn")

var deck = ['leftCard', 'leftCard', 'leftCard', 'rightCard', 'rightCard', 'rightCard', 'boostCard', 'boostCard', 'killCard', 'killCard', 'policeCard', 'ambulanceCard', 'busCard']

var handSize = 3
var hand = []
var discardPile = []

# Called when the node enters the scene tree for the first time.
func _ready():
	deck = shuffleList(deck)

func discardHand():
	for i in range(hand.size()):
		discardPile.push_front(hand.pop_front())
	
func nextHand():
	if(deck.size() < handSize):
		var missingCardCount = handSize - deck.size()
		for i in range(deck.size()):
			hand.push_front(deck.pop_front())
		deck = shuffleList(discardPile)
		discardPile = []
		for i in range(missingCardCount):
			hand.push_front(deck.pop_front())
		displayHand()
	else:
		for i in range(handSize):
			hand.push_front(deck.pop_front())
		displayHand()
	
func shuffleList(list):
	var shuffledList = []
	var indexList = range(list.size())
	for i in range(list.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledList.append(list[x])
		indexList.remove(x)
		list.remove(x)
	return shuffledList

func displayHand():
	for i in range(hand.size()):
		var card
		if(hand[i] == 'leftCard'):
			card = leftCard.instance()
		if(hand[i] == 'rightCard'):
			card = rightCard.instance()
		if(hand[i] == 'killCard'):
			card = killCard.instance()
		if(hand[i] == 'boostCard'):
			card = boostCard.instance()
		if(hand[i] == 'policeCard'):
			card = policeCard.instance()
		if(hand[i] == 'ambulanceCard'):
			card = ambulanceCard.instance()
		if(hand[i] == 'busCard'):
			card = busCard.instance()
			
		get_parent().add_child(card)
		card.position = Vector2(-50 * (i -1), 50)
		
func getHandSize():
	return hand.size()
