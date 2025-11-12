class_name PlayerFall
extends PlayerState

const COYOTE_JUMP_TIME: float = 0.18

var coyote_jump_timer: Timer
var can_coyote_jump: bool = false

func Enter() -> void:
	super.Enter()
	if get_children().size() > 0:
		coyote_jump_timer = get_child(0)
	if !coyote_jump_timer or coyote_jump_timer is not Timer:
		coyote_jump_timer = Utils.create_timer(COYOTE_JUMP_TIME)
		add_child(coyote_jump_timer)
		coyote_jump_timer.timeout.connect(_on_coyote_jump_timer_timeout)
	coyote_jump_timer.start()
	can_coyote_jump = true
	player_sprite.play("fall")

func PhysicsUpdate(delta: float) ->void:
	if Input.is_action_just_pressed("jump"):
		if (can_coyote_jump and not is_jumping) or (jump_remaining > 0 and is_jumping):
			TransitionState.emit("jump")
		elif jump_remaining - 1 > 0 and not is_jumping:
			jump_remaining -= 1
			TransitionState.emit("jump")
		jump_request = true
		jump_request_timer.start()


	player.velocity.y += FALL_GRAVITY * delta
	_move_player()
	player.move_and_slide()
	
	var direction = Input.get_axis("move_left", "move_right")
	var player_direction = -1 if player_sprite.flip_h else 1
	if player.is_on_wall() and direction == player_direction:
		TransitionState.emit("wallslide")
	if player.is_on_floor():
		TransitionState.emit("idle")
	if Input.is_action_just_pressed("dash") and dash_left > 0:
		TransitionState.emit("dash")
	if input_enabled and Input.is_action_just_pressed("attack"):
		TransitionState.emit("attack")

func Exit() -> void:
	is_jumping = false

func _on_coyote_jump_timer_timeout() -> void:
	can_coyote_jump = false
