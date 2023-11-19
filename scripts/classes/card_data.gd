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

# Need to figure out how to attach special behaviour to this thing
# Like revealing other cards after using this one
#
# Also, maybe should add optional @export var sharder : Shader(Material?)
# field to allow for card animation through shaders
