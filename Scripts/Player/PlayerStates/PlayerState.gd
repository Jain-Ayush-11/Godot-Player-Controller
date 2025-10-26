class_name PlayerState
extends State

const FALL_GRAVITY: float = 1800
const GRAVITY: float = 720
const JUMP_BURST_SPRITE_OFFSET: float = -165.0

static var player: Player
static var player_sprite: AnimatedSprite2D
static var jump_request_timer: Timer
static var jump_burst_sprite: AnimatedSprite2D
static var player_normal_collision_shape: CollisionShape2D
static var player_attack_collision_shape: CollisionShape2D
static var attack_hit_box_area: Area2D

static var is_player_facing_right: bool = true
static var is_jumping: bool = false
static var is_dashing: bool = false

static var jump_request: bool = false
static var jump_remaining: int
static var dash_left: int
static var input_enabled: bool = true


func Enter() -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")

	var player_children = player.get_children()
	if not player_sprite or not jump_request_timer:
		for child in player_children:
			if child is AnimatedSprite2D:
				if not player_sprite and child.name == "PlayerSprite":
					player_sprite = child
				elif not jump_burst_sprite and child.name == "JumpBurstSprite":
					jump_burst_sprite = child
			if child is Timer and child.name == "JumpRequestTimer" and not jump_request_timer:
				jump_request_timer = child
				jump_request_timer.timeout.connect(_on_jump_request_timer_timeout)
			if child is CollisionShape2D:
				if child.name == "NormalCollisionShape":
					player_normal_collision_shape = child
				elif child.name == "AttackCollisionShape":
					player_attack_collision_shape = child
			if child is Area2D and child.name == "AttackHitBox":
				attack_hit_box_area = child


func _on_jump_request_timer_timeout() -> void:
	jump_request = false


func _move_player() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction and input_enabled:
		_flip_player(direction)
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)


func _flip_player(direction: float) -> void:
	is_player_facing_right = false if direction < 0 else true
	player_sprite.flip_h = true if direction < 0 else false

	if direction > 0:
		player_normal_collision_shape.position.x = abs(player_normal_collision_shape.position.x)
		player_attack_collision_shape.position.x = abs(player_attack_collision_shape.position.x)
		attack_hit_box_area.scale.x = 1
	else:
		player_normal_collision_shape.position.x = -abs(player_normal_collision_shape.position.x)
		player_attack_collision_shape.position.x = -abs(player_attack_collision_shape.position.x)
		attack_hit_box_area.scale.x = -1
