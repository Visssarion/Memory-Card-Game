extends Node2D

class_name Card

signal clicked(card : Card)

var card_data: CardData

## Recieves a signal if mouse interacts with a card.
## Used to check if card was clicked
func _on_area_2d_input_event(viewport, event : InputEventMouseButton, shape_idx):
	if event.pressed == false: # false - button release
		clicked.emit(self)
