class_name PlayerJump
extends PlayerState

const MAX_JUMP_TIME: float = 0.265

var can_jump_higher: bool = false
var timer: Timer = null
var JUMP_VELOCITY: float


func Enter() -> void:
	super.Enter()
	JUMP_VELOCITY = player.JUMP_VELOCITY
	is_jumping = true
	jump_request = false
	jump_request_timer.stop()

	if get_children().size() > 0:
		timer = get_child(0)
	
	if !timer or timer is not Timer:
		timer = Utils.create_timer(MAX_JUMP_TIME)
		add_child(timer)
		timer.timeout.connect(_on_timer_timeout)
	
	player_sprite.play("jump")
	if jump_remaining != player.JUMP_COUNT:
		_create_jump_burst_effect()
	jump_remaining -= 1
	player.velocity.y = JUMP_VELOCITY
	can_jump_higher = true
	timer.start()

func PhysicsUpdate(delta: float) ->void:
	if not jump_burst_sprite.is_playing():
		jump_burst_sprite.visible = false

	if Input.is_action_just_pressed("jump") and jump_remaining > 0:
		jump_remaining -= 1
		TransitionState.emit("jump")

	if can_jump_higher and Input.is_action_pressed("jump"):
		player.velocity.y = JUMP_VELOCITY
	else:
		player.velocity.y += GRAVITY * delta
	if Input.is_action_just_pressed("dash") and dash_left > 0:
		TransitionState.emit("dash")

	_move_player()

	player.move_and_slide()


	if player.velocity.y >= 0:
		TransitionState.emit("fall")

func _on_timer_timeout() -> void:
	can_jump_higher = false

func _create_jump_burst_effect() -> void:
	jump_burst_sprite.flip_h = player_sprite.flip_h
	jump_burst_sprite.offset.x = JUMP_BURST_SPRITE_OFFSET
	if jump_burst_sprite.flip_h:
		jump_burst_sprite.offset.x *= -1
	jump_burst_sprite.visible = true
	jump_burst_sprite.play("default")
