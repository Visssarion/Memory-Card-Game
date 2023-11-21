## 
extends Node

class_name Game

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

# This method finalizes the game, and throws either in endless mode new cards on the board, or in
# story 
func finalize_game() -> void:
	var opened_all = cards_on_board.map(func(card): return card.opened)
	if not opened_all.find(false):
		print("CHANGING SCENE, BOARD HAS BEEN CLEARED, OR ADD NEW CARDS")

# Here we determine the winner of each result phase, runs before reseting the gameloop
func determine_win() -> void:
	var timeout = 3  # Default timeout for a loss
	# If we have a match, we obviously win
	if selected_card_a.card_data.name == selected_card_b.card_data.name:
		timeout = 1  # Reduce timer to keep the player engadget
		print('WINNER')
		# Destroy cards? TODO
		finalize_game()

	var timer = get_timer(timeout)  # Obtain timeout component
	timer.timeout.connect(set_result_state)  # Connect the finalize method to the timeout
	timer.start()  # Start the timeout counting down to execute the method hold by the timer

# Check result state, reset gameloop
func set_result_state() -> void:
	# Any other gamephase then PICK_B should not trigger this method
	if gamephase != gamephases.RESULT: return
	# Reset gamephase to PICK_A so the user is able to make a new selection
	gamephase = gamephases.PICK_A
	# If the current round was not a win, flip the cards back facedown
	if selected_card_a.card_data.name != selected_card_b.card_data.name:
		selected_card_a.opened = false  # Close cards incase of invalid match
		selected_card_b.opened = false  # Close cards incase of invalid match

func get_timer(wait_time: int = 5) -> Timer:
	var timer = get_node("setTimout")  # Get setTimeout node (Timer)
	timer.autostart = true  # Make sure it automatically starts
	timer.one_shot = false  # The timer is allowed to run more then just once
	timer.wait_time = wait_time  # Set the time before the timer executes its method
	return timer  # Return the timer element

# Method which executes after card has been clicked
func on_click(card):
	# Cancel click if card is already open, we don't want to progress the gamephase
	if card.opened or gamephase == gamephases.RESULT: return

	# Check current gamestate
	if (gamephase == gamephases.PICK_A):
		gamephase = gamephases.PICK_B  # Change current gamestate to the next one
		selected_card_a = card  # The current card clicked will be Card A.
		card.opened = true  # Flip the card face up
	# Check current gamestate
	elif (gamephase == gamephases.PICK_B):
		gamephase = gamephases.RESULT  # Change current gamestate to the next one
		selected_card_b = card  # The current card clicked will be Card B.
		card.opened = true  # Flip the card face up
		determine_win()  # Check for a winner, execute timer to flip gamestate back to PICK_A

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
