extends Resource

class_name CardData
## Class for serializable objects of cards.
##
## Class to store data of a given card.
##
## Inherits Resource to make process of making new cards easier



## Card's image
@export var image: Texture2D
## Card's name.
## Note that this is a [StringName] field instead of [String]
## to speed up '==' calculations.
@export var name: StringName
