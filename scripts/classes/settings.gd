extends Resource

class_name GameSettings

@export_group("DEBUG Settings")
## When TRUE run game in DEBUG mode[br]
@export var DEBUG: bool = false

@export_group("Game Settings")
enum gamemodes {STORY, ENDLESS}  # Available gamemodes
## Available gamemodes for the current board
@export var gamemode: gamemodes
## The next scene to load when winning the game[br]
## [br][code]The board has to be cleared and the gamemode has to be story in order to load a new scene[/code][br][br]
@export var next_scene: PackedScene

@export_group("Round Settings")
## [b]Value for debugging purpose:[/b][br][code]ONLY CHANGE IN DEV MODE[/code][br][br]
## Cooldown duration after picking wrong card
@export var loss_timeout: float = 3.0
## [b]Value for debugging purpose:[/b][br][code]ONLY CHANGE IN DEV MODE[/code][br][br]
## Cooldown duration after picking right card
@export var win_timeout: float = 1.0

func _init(DEBUG: bool, gamemode: gamemodes, next_scene: PackedScene):
	self.DEBUG = DEBUG
	self.gamemode = gamemode
	self.next_scene = next_scene
	set_debug_env()

func set_debug_env():
	if not self.DEBUG: return  # If production build, return
	# Set annoying memory timer to 1 second if debug is enabled
	self.loss_timeout = 1.0

func progress_scene():
	return self.next_scene.instantiate()
