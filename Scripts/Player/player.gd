class_name Player
extends CharacterBody2D

const KNOCKBACK_FORCE_X: float = 600.0
const KNOCKBACK_FORCE_Y: float = -100.0
const PLAYER_COLLISION_LAYER: int = 2

signal take_damage(damage: float, knockback: bool)
signal attack_hit(body: Node2D, damage: float)

@export var JUMP_COUNT: int = 2
@export var DASH_COUNT: int = 1
@export var SPEED: float = 200
@export var JUMP_VELOCITY: float = -250.0
@export var DASH_SPEED: float = 1000.0
@export var HEALTH_POINT: float = 100.0
@export var PRIMARY_ATTACK_POWER: float = 10

var _knockback_direction: Vector2

@onready var jump_burst_sprite: AnimatedSprite2D = $JumpBurstSprite
@onready var knock_back_timer: Timer = $KnockBackTimer
@onready var invulnerable_timer: Timer = $InvulnerableTimer
@onready var blink_timer: Timer = $BlinkTimer

func _ready() -> void:
	jump_burst_sprite.visible = false
	take_damage.connect(_on_self_take_damage)
	knock_back_timer.timeout.connect(_on_knock_back_timer_timeout)
	invulnerable_timer.timeout.connect(_on_invulnerable_timer_timeout)
	blink_timer.timeout.connect(_on_blink_timer_timeout)

func _physics_process(delta: float) -> void:
	if not knock_back_timer.is_stopped():
		if _knockback_direction == Vector2.INF:
			_knockback_direction.x = -1 if PlayerState.is_player_facing_right else 1
			_knockback_direction.y = 1
		velocity = Vector2(_knockback_direction.x*KNOCKBACK_FORCE_X, _knockback_direction.y*KNOCKBACK_FORCE_Y)

func _on_self_take_damage(damage: float, knockback: bool = false, hit_direction: Vector2 = Vector2.ZERO, make_pause: bool = false):
	if not PlayerState.is_invulnerable:
		HEALTH_POINT -= damage

		if make_pause:
			var original_color = modulate
			get_tree().paused = true
			modulate = Color(1000,1000,1000)
			await get_tree().create_timer(0.2, true).timeout
			modulate = original_color
			get_tree().paused = false

		PlayerState.is_invulnerable = true
		collision_layer = 0
		invulnerable_timer.start()
		blink_timer.start()
		PlayerState.player_sprite.visible = !PlayerState.player_sprite.visible

		print(HEALTH_POINT)

		if knockback:
			_knockback(hit_direction)

func _knockback(hit_direction: Vector2):
	PlayerState.input_enabled = false
	_knockback_direction = hit_direction
	knock_back_timer.start()

func _on_knock_back_timer_timeout() -> void:
	PlayerState.input_enabled = true
	velocity = Vector2.ZERO
	_knockback_direction = Vector2.INF

func _on_invulnerable_timer_timeout() -> void:
	PlayerState.is_invulnerable = false
	blink_timer.stop()
	PlayerState.player_sprite.visible = true
	collision_layer = PLAYER_COLLISION_LAYER

func _on_blink_timer_timeout() -> void:
	PlayerState.player_sprite.visible = !PlayerState.player_sprite.visible
	blink_timer.start()

func is_player_invulnerable() -> bool:
	return PlayerState.is_invulnerable
