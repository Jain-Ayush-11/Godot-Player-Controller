class_name Player
extends CharacterBody2D

signal take_damage(damage: float)
signal attack_hit(body: Node2D, damage: float)

@export var JUMP_COUNT: int = 2
@export var DASH_COUNT: int = 1
@export var SPEED: float = 200
@export var JUMP_VELOCITY: float = -250.0
@export var DASH_SPEED: float = 1000.0
@export var HEALTH_POINT: float = 100.0
@export var PRIMARY_ATTACK_POWER: float = 10

@onready var jump_burst_sprite: AnimatedSprite2D = $JumpBurstSprite

func _ready() -> void:
	jump_burst_sprite.visible = false
	take_damage.connect(_on_self_take_damage)

func _on_self_take_damage(damage: float):
	HEALTH_POINT -= damage
	print(HEALTH_POINT)
