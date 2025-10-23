class_name PlayerRun
extends PlayerState

func Enter() -> void:
	super.Enter()
	player_sprite.play("run")

func PhysicsUpdate(delta: float) ->void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		player_sprite.flip_h = true if direction < 0 else false
		player.velocity.x = direction * SPEED
	else:
		TransitionState.emit(self, "idle")

	if (Input.is_action_just_pressed("jump") or jump_request) and player.is_on_floor():
		TransitionState.emit(self, "jump")


	if !player.is_on_floor():
		TransitionState.emit(self, "fall")

	player.move_and_slide()

func Exit() -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
	player.move_and_slide()
