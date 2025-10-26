class_name PlayerWallSlide
extends PlayerState

const WALL_SLIDE_VELOCITY: float = 50.0
const WALL_JUMP_PUSHBACK_FORCE: float = 1250.0
const PUSHBACK_INPUT_DISABLE_WAIT_TIME: float = 0.25

var wall_dir: int
var player_sprite_flip_val: bool
var initial_player_direction: int

var pushback_input_disable_timer: Timer

func Enter() -> void:
	dash_left = DASH_COUNT
	jump_remaining = PLAYER_JUMP_COUNT
	is_jumping = false

	player.velocity.x = 0
	player_sprite_flip_val = player_sprite.flip_h
	player_sprite.flip_h = not player_sprite_flip_val
	wall_dir = -1 if player_sprite_flip_val else 1
	initial_player_direction = wall_dir
	if !pushback_input_disable_timer:
		pushback_input_disable_timer = Utils.create_timer(PUSHBACK_INPUT_DISABLE_WAIT_TIME)
		add_child(pushback_input_disable_timer)
		pushback_input_disable_timer.timeout.connect(_on_pushback_input_disable_timer_timeout)
	player_sprite.play("wall_slide")

func PhysicsUpdate(delta: float) -> void:
	if (wall_dir == -1 and Input.is_action_pressed("move_left")) or (wall_dir == 1 and Input.is_action_pressed("move_right")):
		player.velocity.y = WALL_SLIDE_VELOCITY
	else:
		TransitionState.emit("fall")
	player.move_and_slide()
	
	if player.is_on_floor():
		TransitionState.emit("idle")
	if Input.is_action_just_pressed("jump") and not player.is_on_floor():
		player.velocity.x = -1 * wall_dir * WALL_JUMP_PUSHBACK_FORCE
		input_enabled = false
		pushback_input_disable_timer.start()
		TransitionState.emit("jump")

func _on_pushback_input_disable_timer_timeout() -> void:
	input_enabled = true
