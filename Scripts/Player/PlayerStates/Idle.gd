class_name PlayerIdle
extends PlayerState

func Enter() -> void:
	super.Enter()
	player_sprite.play("idle")

func PhysicsUpdate(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		TransitionState.emit(self, "run")
	player.move_and_slide()

	if (Input.is_action_just_pressed("ui_accept") or jump_request) and player.is_on_floor():
		TransitionState.emit(self, "jump")

	if !player.is_on_floor():
		TransitionState.emit(self, "fall")
