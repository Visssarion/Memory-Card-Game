class_name GameSettings

@export_group("Game Settings")
enum gamemodes {STORY, ENDLESS}  # Available gamemodes
@export var gamemode_story = gamemodes.STORY
@export var gamemode_endless = gamemodes.ENDLESS
## Available gamemodes for the current board
@export var gamemode: gamemodes = gamemodes.ENDLESS

@export_group("Round Settings")
## [b]Value for debugging purpose:[/b][br][code]ONLY CHANGE IN DEV MODE[/code][br][br]
## Cooldown duration after picking wrong card
@export var loss_timeout: float = 1.0
## [b]Value for debugging purpose:[/b][br][code]ONLY CHANGE IN DEV MODE[/code][br][br]
## Cooldown duration after picking right card
@export var win_timeout: float = 1.0
