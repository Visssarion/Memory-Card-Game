extends Node

class_name Deck

var deck_name: String
var deck: Array[CardData]  # Holds card data such as image and name

func dir_contents(path):
	# Iterate over resource path, Fills Array[CardData] based on the tres files located in the provided path
	# Such a folder should only contain card prefabs with CardData class.
	var dir = DirAccess.open(path)  # read the path of the directory
	if dir:  # If the directory exists
		dir.list_dir_begin()  # Initialize stream
		var file_name = dir.get_next()  # Get next item in the stream
		while file_name != "":  # Loop until we have no files anymore
			if not dir.current_is_dir():  # If the file is not a directory, we keep it
				var card = load("%s/%s" % [path, file_name])  # Format the path and try to load the card
				deck.append(card)  # Append the card to our deck
			file_name = dir.get_next()  # Update the file_name with the next file in the stream
	else:  # If anything goes wrong, we let the art people know in the console.
		print("An error occurred when trying to access the path for the card deck located in ; res://cards/resources/Themes/***.")

func fetch():
	# Fetch the requested deck based on the name the class was initialized with
	# Checks if folder exists; Generates CardData; Creates a set of cards used for the game
	var path: String = "res://cards/resources/Themes/%s" % deck_name  # Format Deck folder location
	dir_contents(path)  # Iterate over folder content, determine deck
	return deck  # Return the deck we just created dynamically
