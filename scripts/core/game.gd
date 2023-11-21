extends Node

@export_group("Board Settings")
@export_range(2, 16, 2) var rows: int = 2  # Dynamically set the amount of cards on the board
@export var card_theme: Array[CardData]  # Holds card data such as image and name
@export var card_prefeb: PackedScene  # Holds Card prefab

enum gamestates {PICK_A, PICK_B, RESULT}  # Available gamestates
var gamestate: gamestates  # Current state of the gameloop

var cards_on_board: Array[Card]  # Private var which holds current cards on the board
var selected_card_a: Card  # Player selected first choice
var selected_card_b: Card  # Player selected second choice

func on_click(card):
	print("YOMAMAMAWASHERE")
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
	const starting_pos: Vector2 = Vector2(0, 0)
	for row in range(rows):  # iterate over imaginary rows
		for col in range(rows):  # Iterate over imaginary cols
			var card_index = row*rows+col  # Determine current Array index
			var card = cards_on_board[card_index]  # Obtain card from the current board
			card.card_data = card_theme[card_index]  # Set the card_date for the card
			card.position = Vector2((512+15)*row, (512+15)*col)  # Set position of the card
			card.update_face()  # Update the face of the card
			card.clicked.connect(on_click)  # Execute card click
			add_child(card)  # Spawn the card in the world
