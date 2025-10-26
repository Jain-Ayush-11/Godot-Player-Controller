class_name Player
extends CharacterBody2D

@export var JUMP_COUNT: int = 2
@export var DASH_COUNT: int = 1
@export var SPEED: float = 200
@export var JUMP_VELOCITY: float = -250.0
@export var PLAYER_DASH_SPEED: float = 1000.0

@onready var jump_burst_sprite: AnimatedSprite2D = $JumpBurstSprite

func _ready() -> void:
	jump_burst_sprite.visible = false
