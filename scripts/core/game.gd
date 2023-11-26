## Core logic of each board.
extends Node

class_name Game


@export_group("Game Settings")
## Settings for current level.
@export var settings: GameSettings

@export_group("Board Settings")
## Dynamically set the amount of cards on the board[br]
## [br][code]Impacts amount of cols AND rows of the board[/code][br][br]
@export_range(2, 16, 2) var rows: int = 2
## Total amount of cards required on the board in order to win and move on to the next scene[br]
## [br][code]When value is 0, all cards need to be matched before next scene can be loaded[/code][br][br]
## Note: On endless mode, it detemines when new cards will spawn
@export var cards_left_for_win: int = 0

@export_group("Card Settings")
## The name of the Card deck.[br][br]The name of the deck represents a folder which should be located in[br]
## [br][code]res://cards/resources/Themes/DECKNAME[/code][br][br]
## If a card deck doesn't exists, game won't load and throws a print statement
@export var deck_name: String = "FiftySpaceHorror"
## Holds pixel size of each card art[br][br][code]default 512*512[/code]
@export var pixelsize: int = 512
## Pixel distant within the grid between cards[br][br][code]default 15px[/code]
@export var gridsize: int = 15

enum gamephases {PICK_A, PICK_B, RESULT}  # Available gamestates
var gamephase: gamephases = gamephases.PICK_A  # Current state of the gameloop

var deck: Deck
var card_theme: Array[CardData]  # Holds card data such as image and name
var cards_on_board: Array[Card]  # Private var which holds current cards on the board
var selected_card_a: Card  # Player selected first choice
var selected_card_b: Card  # Player selected second choice
var card_prefab: PackedScene = load("res://nodes/objects/card.tscn")  # Holds Card prefab

## This method finalizes the game, and throws either in endless mode new cards on the board, or in
## story 
func finalize_game() -> void:
	# Look for cards that have not been opened yet. If all cards are opened this should return an
	# empty Array.
	var closed_cards = cards_on_board.filter(func(card): return not card.opened)
	# Check if the array is equal or lower then the amount of cards required on the board.
	if len(closed_cards) <= cards_left_for_win:
		clear_memory()  # Clear all relevant references
		if settings.gamemode == GameSettings.gamemodes.STORY:
			## Obtain current scene
			progress_story()
		elif settings.gamemode == GameSettings.gamemodes.ENDLESS:
			generate_game()  # Generate new board / new game

## Unloads current scene and loads new scene
func progress_story():
	#var root = get_tree().get_root()  # Get root Node
	#var current_scene = root.get_child(root.get_child_count() - 1)  # Get current scene
	var new_scene = settings.progress_scene()  # Story Handler
	add_child(new_scene)  # Configure new scene
	get_tree().set_current_scene(new_scene)

## Here we determine the winner of each result phase, runs before reseting the gameloop
func determine_win() -> void:
	# If we have a match, we obviously win
	var round_timeout = settings.loss_timeout
	if selected_card_a.card_data.name == selected_card_b.card_data.name:
		round_timeout = settings.win_timeout  # Reduce timer to keep the player engadget
		print('WINNER, TODO HERE :eyes:')
		# Destroy cards? TODO

	var timer = $setTimeout  # Obtain timeout component
	timer.wait_time = round_timeout  # Connect the finalize method to the timeout
	timer.start()  # Start the timeout counting down to execute the method hold by the timer

## Check result state, reset gameloop
func set_result_state() -> void:
	# Any other gamephase then PICK_B should not trigger this method
	if gamephase != gamephases.RESULT: return
	# Reset gamephase to PICK_A so the user is able to make a new selection
	gamephase = gamephases.PICK_A
	# If the current round was not a win, flip the cards back facedown
	if selected_card_a && selected_card_b && \
		selected_card_a.card_data.name != selected_card_b.card_data.name:
		selected_card_a.opened = false  # Close cards incase of invalid match
		selected_card_b.opened = false  # Close cards incase of invalid match

	finalize_game()  # Check if the board can be cleared.

## Method which executes after card has been clicked
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

## Fetch Card Deck
func obtain_deck():
	deck = Deck.new()  # Initialize a new deck
	deck.deck_name = deck_name  # Set the deck name
	card_theme = deck.fetch()  # Obtain the deck
	card_theme.shuffle()  # Pre shuffle the deck
	card_theme = card_theme.slice(0, (rows*rows) / 2)  # Pick the amount of cards required to fill the board

	## Duplicate cards
	card_theme += card_theme  # Make a set of cards (Duplicate them)
	card_theme.shuffle()  # Shuffle cards for the game

## Instantiate cards to game board from resources
func layout_cards_on_board():
	for card in card_theme:  # For each card in our Theme
		var instance: Node2D = card_prefab.instantiate()  # Intantiate card node
		cards_on_board.append(instance)  # place card on the board

## Position cards, obtain starting position
func render_game_board():
	var spawn_offset: int = rows / 2 * (pixelsize + gridsize) * -1 + pixelsize / 2  # wtf,!? Vissa!
	var starting_pos: Vector2 = Vector2(spawn_offset, spawn_offset)  # Start position of first card
	for row in range(rows):  # iterate over over rows
		for col in range(rows):  # Iterate over imaginary cols
			var card_index = row*rows+col  # Determine current Array index
			var card = cards_on_board[card_index]  # Obtain card from the current board
			card.card_data = card_theme[card_index]  # Set the card_date for the card
			card.position = Vector2((pixelsize+gridsize)*row, (pixelsize+gridsize)*col) + starting_pos # Set position of the card
			card.update_visual()  # Update the face of the card
			card.clicked.connect(on_click)  # Execute card click
			add_child(card)  # Spawn the card in the world

## Clears memory array with prefabs in scene
func clear_memory():
	deck.clear()  # Make sure to clear deck (In case for endless mode)
	card_theme.clear()  # Make sure to clear references from the current card theme
	selected_card_a = null  # Set card A to Nill to prevent If statement from firing
	selected_card_b = null  # Set card B to Nill to prevent If statement from firing
	# Remove current items on the board from the game scene
	for item in cards_on_board:
		remove_child(item)
		item.queue_free()

	# Make sure to also remove camera from scene to avoid camera script naming collisions
	$GameCamera2D.queue_free()
	# Clear all references
	cards_on_board.clear()

func generate_game():
	## Generates a new board based on the gamesettings and lays it out for the user after which the user can play the game
	obtain_deck()
	layout_cards_on_board()
	render_game_board()
	$GameCamera2D.update_scale(rows, pixelsize, gridsize)  # Attach camera

func _ready():
	$setTimeout.timeout.connect(set_result_state)  # Connects Timer signal to self.class method
	generate_game()  # Start game
