class_name PlayerIdle
extends PlayerState

var DASH_COUNT: int
@export var something: CharacterBody2D

func Enter() -> void:
	super.Enter()
	print(player.position, " ", something.position)
	DASH_COUNT = player.DASH_COUNT
	if player.is_on_floor() or player.is_on_wall():
		dash_left = DASH_COUNT
		is_jumping = false
		jump_remaining = player.JUMP_COUNT
	player_sprite.play("idle")
	player.velocity.x = move_toward(player.velocity.x, 0, abs(player.velocity.x))


func PhysicsUpdate(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		TransitionState.emit("run")
	player.move_and_slide()

	if ((Input.is_action_just_pressed("ui_accept") and input_enabled) or jump_request) and player.is_on_floor():
		TransitionState.emit("jump")

	if !player.is_on_floor():
		TransitionState.emit("fall")
	
	if input_enabled and Input.is_action_just_pressed("dash") and dash_left > 0:
		TransitionState.emit("dash")
	
	if input_enabled and Input.is_action_just_pressed("attack"):
		TransitionState.emit("attack")
