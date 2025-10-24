class_name PlayerJump
extends PlayerState

const MAX_JUMP_TIME: float = 0.265

var can_jump_higher: bool = false
var timer: Timer = null

func Enter() -> void:
	jump_remaining -= 1
	is_jumping = true
	jump_request = false
	jump_request_timer.stop()

	super.Enter()
	if get_children().size() > 0:
		timer = get_child(0)
	
	if !timer or timer is not Timer:
		timer = Utils.create_timer(MAX_JUMP_TIME)
		add_child(timer)
		timer.timeout.connect(_on_timer_timeout)
	
	player_sprite.play("jump")
	player.velocity.y = JUMP_VELOCITY
	can_jump_higher = true
	timer.start()

func PhysicsUpdate(delta: float) ->void:
	if Input.is_action_just_pressed("jump") and jump_remaining > 0:
		jump_remaining -= 1
		player.velocity.y = JUMP_VELOCITY
	if can_jump_higher and Input.is_action_pressed("jump"):
		player.velocity.y = JUMP_VELOCITY
	else:
		player.velocity.y += GRAVITY * delta
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		player_sprite.flip_h = true if direction < 0 else false
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)

	player.move_and_slide()

	if player.velocity.y >= 0:
		TransitionState.emit(self, "fall")

func _on_timer_timeout() -> void:
	can_jump_higher = false
