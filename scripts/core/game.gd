## 
extends Node

@export_group("Board Settings")
@export_range(2, 16, 2) var rows: int = 2  # Dynamically set the amount of cards on the board
@export var card_prefeb: PackedScene  # Holds Card prefab

@export_group("Card Settings")
@export var card_theme: Array[CardData]  # Holds card data such as image and name
@export var pixelsize: int = 512  # Holds pixel size of each card art
@export var gridsize: int = 15  # Pixel distant within the grid between cards

enum gamephases {PICK_A, PICK_B, RESULT}  # Available gamestates
var gamephase: gamephases = gamephases.PICK_A  # Current state of the gameloop

var cards_on_board: Array[Card]  # Private var which holds current cards on the board
var selected_card_a: Card  # Player selected first choice
var selected_card_b: Card  # Player selected second choice

# Here we determine the winner of each result phase
func determine_win():
	if selected_card_a.card_data.name != selected_card_b.card_data.name:
		selected_card_a.opened = false  # Close cards incase of invalid match
		selected_card_b.opened = false  # Close cards incase of invalid match
	else:
		print('WINNER')
		# Destroy cards? TODO

# Method which executes after card has been clicked
func on_click(card):
	# Cancel click if card is already open, we don't want to progress the gamephase
	if card.opened: return

	# Check current gamestate
	if (gamephase == gamephases.PICK_A):
		gamephase = gamephases.PICK_B  # Change current gamestate to the next one
		card.opened = true
		print("YOMAMAMAWASHERE")
	# Check current gamestate
	elif (gamephase == gamephases.PICK_B):
		gamephase = gamephases.RESULT  # Change current gamestate to the next one
		card.opened = true
		print("YODADDYWASHERE")
	# Check current gamestate
	elif (gamephase == gamephases.RESULT):  # Change current gamestate to the next one
		gamephase = gamephases.PICK_A
		print(card)

func _ready():
	## Duplicate cards
	card_theme += card_theme  # Make a set of cards (Duplicate them)
	card_theme.shuffle()  # Shuffle cards

	## Instantiate cards to game board from resources
	for card in card_theme:  # For each card in our Theme
		var instance: Node2D = card_prefeb.instantiate()  # Intantiate card node
		cards_on_board.append(instance)  # place card on the board

	# Position cards, obtain starting position
	var spawn_offset: int = rows / 2 * (pixelsize + gridsize) * -1 + pixelsize / 2
	var starting_pos: Vector2 = Vector2(spawn_offset, spawn_offset)
	for row in range(rows):  # iterate over over rows
		for col in range(rows):  # Iterate over imaginary cols
			var card_index = row*rows+col  # Determine current Array index
			var card = cards_on_board[card_index]  # Obtain card from the current board
			card.card_data = card_theme[card_index]  # Set the card_date for the card
			card.position = Vector2((pixelsize+gridsize)*row, (pixelsize+gridsize)*col) + starting_pos # Set position of the card
			card.update_face()  # Update the face of the card
			card.clicked.connect(on_click)  # Execute card click
			add_child(card)  # Spawn the card in the world
			print(card.position)

	# Attach camera
	$GameCamera2D.update_scale(rows, pixelsize, gridsize)
