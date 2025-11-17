class_name Enemy
extends CharacterBody2D

@export var health: float = 40
@export var touch_damage: float = 20

@onready var player: Player = %Player
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_player: RayCast2D = $RayCastPlayer
@onready var ray_cast_ledge: RayCast2D = $RayCastLedge

var is_facing_right: bool = true
var direction: float = 1.0
var total_health: float

func _ready() -> void:
	total_health = health
	player.attack_hit.connect(on_player_attack_hit)


func on_player_attack_hit(body: Node2D, damage_taken: float):
	if body == self:
		health -= damage_taken
		await hit_freeze()


func hit_freeze(duration := 0.2):
	var original_color = sprite.modulate
	get_tree().paused = true
	modulate = Color(1000,1000,1000)
	await get_tree().create_timer(duration, true).timeout
	get_tree().paused = false
	modulate = original_color
