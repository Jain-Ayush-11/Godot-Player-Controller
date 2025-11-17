class_name BossEnemy
extends Enemy

@export var FALL_GRAVITY: float = 1800
@export var GRAVITY: float = 720
@export var boss_arena_area: Area2D

var is_player_in_arena: bool
var is_second_phase: bool = false
var damage: float

@onready var attack_hit_box: Area2D = $AttackHitBox

func _ready() -> void:
	super._ready()
	boss_arena_area.body_entered.connect(_on_boss_arena_area_body_entered)
	boss_arena_area.body_exited.connect(_on_boss_arena_area_body_exited)
	attack_hit_box.body_entered.connect(on_attack_hit_box_body_entered)


func _on_boss_arena_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_arena = true


func _on_boss_arena_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_arena = false


func on_player_attack_hit(body: Node2D, damage_taken: float):
	if body == self:
		print("HIT")
		health -= damage_taken
		await hit_freeze(0.05)
	if health <= total_health/2 and not is_second_phase:
		initiate_second_phase()


func initiate_second_phase() -> void:
	is_second_phase = true
	var original_color = sprite.modulate
	get_tree().paused = true
	modulate = Color(1000,0,0)
	await get_tree().create_timer(1, true).timeout
	get_tree().paused = false
	modulate = original_color


func on_attack_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.take_damage.emit(damage, false, Vector2.ZERO, true)
