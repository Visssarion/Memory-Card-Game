extends Node2D

class_name Card

signal clicked(card : Card)

var card_data: CardData

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

func update_face():
	$Image.texture = card_data.image;

## Activates when mouse button is pressed
func _on_click():
	pass

var opened = false

## Activates when mouse button is released (if still on card)
func _on_click_confirm():
	clicked.emit(self)
	if opened:
		$AnimationPlayer.play("card_close")
	else:
		$AnimationPlayer.play("card_open")
	opened = !opened
	


func _on_area_2d_mouse_entered():
	pass

func _on_area_2d_mouse_exited():
	pass
