class_name Enemy
extends CharacterBody2D

@export var health: float = 40
@export var damage: float = 20

@onready var player: Player = %Player
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var touch_hit_box: Area2D = $TouchHitBox
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_player: RayCast2D = $RayCastPlayer
@onready var ray_cast_ledge: RayCast2D = $RayCastLedge

var is_facing_right: bool = true
var direction: float = 1.0


func _ready() -> void:
	player.attack_hit.connect(on_player_attack_hit)
	if touch_hit_box and not touch_hit_box.body_entered.is_connected(_on_touch_hit_box_body_entered):
		touch_hit_box.body_entered.connect(_on_touch_hit_box_body_entered)


func on_player_attack_hit(body: Node2D, damage_taken: float):
	if body == self:
		health -= damage_taken
		await hit_freeze()


func hit_freeze(duration := 0.2):
	var original_color = sprite.modulate
	get_tree().paused = true
	modulate = Color(300,300,300)
	await get_tree().create_timer(duration, true).timeout
	get_tree().paused = false
	modulate = original_color


func _on_touch_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var _hitbox_direction: Vector2 = Vector2(1 if player.global_position.x-global_position.x > 0 else -1, 1)
		player.take_damage.emit(damage, true, _hitbox_direction)
