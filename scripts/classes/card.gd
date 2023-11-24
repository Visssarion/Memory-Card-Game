extends Node2D

class_name Card

signal clicked(card : Card)

var card_data: CardData
var opened = false:
	set(new_value):
		if opened != new_value:
			opened = new_value
			if opened:
				_open_card()
			else:
				_close_card()
	get:
		return opened

func _open_card():
	$FlipPlayer.play("open")
	
	
func _close_card():
	$FlipPlayer.play("close")

## Recieves a signal if mouse interacts with a card.
## Used to check if card was clicked
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed == true:
			_on_click()
		else: # - button release
			_on_click_confirm()
	# other possible event type here: InputEventMouseMotion
	# can be used to track position of the mouse inside the card

## Activates when mouse button is pressed
func _on_click():
	pass

## Activates when mouse button is released (if still on card)
func _on_click_confirm():
	clicked.emit(self)

func _on_area_2d_mouse_entered():
	$HoverPlayer.play("hover")

func _on_area_2d_mouse_exited():
	$HoverPlayer.play("unhover")

func update_visual():
	$Sprites/Image.texture = card_data.image;
	$Sprites/BackSide.texture = card_data.image_back;
