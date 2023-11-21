extends Camera2D

## Class to automatically scale camera and not lose any visual info.

@export var default_resolution: Vector2 = Vector2(1920, 1080)

@export var out_of_board_pixel_amount : float = 40

var _default_scale : float = 1

func update_scale(rows: int, pixelsize: int, gridsize: int):
	var board_size = (pixelsize + gridsize) * rows + out_of_board_pixel_amount
	_default_scale = default_resolution.y / board_size
	_on_viewport_size_changed()

func _ready():
	get_viewport().size_changed.connect(_on_viewport_size_changed)

func _on_viewport_size_changed():
	var viewport_size = get_viewport().get_visible_rect().size
	# Calculates difference in scale compared to default resolution
	var viewport_x_scale = viewport_size.x / default_resolution.x
	var viewport_y_scale = viewport_size.y / default_resolution.y
	
	# bro i am so sorry.
	# for more info, check this shit out \/
	# https://user-images.githubusercontent.com/46628714/284697889-febe874f-32da-41d1-88dd-0df9624e21cb.png
	if viewport_x_scale < viewport_y_scale: # empty space vertically
		self.zoom = Vector2(viewport_x_scale, viewport_x_scale) * _default_scale
	else: #                                 # empty space horizontally
		self.zoom = Vector2(viewport_y_scale, viewport_y_scale) * _default_scale
