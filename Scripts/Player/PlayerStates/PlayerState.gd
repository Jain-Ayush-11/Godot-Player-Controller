class_name PlayerState
extends State

const SPEED: float = 200
const JUMP_VELOCITY: float = -275.0
const FALL_GRAVITY: float = 1800
const GRAVITY: float = 720

static var player: CharacterBody2D
static var player_sprite: AnimatedSprite2D
static var is_jumping: bool = false
static var jump_request_timer: Timer
static var jump_request: bool = false

func Enter() -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")

	var player_children = player.get_children()
	if not player_sprite or not jump_request_timer:
		for child in player_children:
			if child is AnimatedSprite2D and not player_sprite:
					player_sprite = child
			if child is Timer and child.name == "JumpRequestTimer" and not jump_request_timer:
				jump_request_timer = child
				jump_request_timer.timeout.connect(_on_jump_request_timer_timeout)

func _on_jump_request_timer_timeout() -> void:
	jump_request = false
