@tool

extends Resource

class_name Phrase

@export var flags: String
@export var text: String:
	set(value):
		text = value
		self.resource_name = value
	get:
		return text
