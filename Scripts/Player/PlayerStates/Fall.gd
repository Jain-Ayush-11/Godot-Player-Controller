class_name PlayerFall
extends PlayerState

const COYOTE_JUMP_TIME: float = 0.18

var coyote_jump_timer: Timer
var can_coyote_jump: bool = false

func Enter() -> void:
	super.Enter()
	coyote_jump_timer = Utils.create_timer(COYOTE_JUMP_TIME)
	add_child(coyote_jump_timer)
	coyote_jump_timer.start()
	can_coyote_jump = true
	coyote_jump_timer.timeout.connect(_on_coyote_jump_timer_timeout)
	player_sprite.play("fall")

func PhysicsUpdate(delta: float) ->void:
	if Input.is_action_just_pressed("jump"):
		if can_coyote_jump and not is_jumping:
			TransitionState.emit(self, "jump")
		jump_request = true
		jump_request_timer.start()

	player.velocity.y += FALL_GRAVITY * delta
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		player_sprite.flip_h = true if direction < 0 else false
		player.velocity.x = direction * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.move_and_slide()
	
	if player.is_on_floor():
		if direction:
			TransitionState.emit(self, "run")
		else:
			TransitionState.emit(self, "idle")

func Exit() -> void:
	is_jumping = false

func _on_coyote_jump_timer_timeout() -> void:
	can_coyote_jump = false
