class_name BossEnemyIdle
extends BossState

func Enter() -> void:
	super.Enter()
	enemy.sprite.play("idle")

func PhysicsUpdate(delta: float) -> void:
	super.PhysicsUpdate(delta)
	enemy.velocity.y += GRAVITY * delta
	enemy.move_and_slide()
	
	if enemy.is_player_in_arena:
		TransitionState.emit("run")
