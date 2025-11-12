class_name EnemyIdle
extends EnemyState

func Enter() -> void:
	super.Enter()
	enemy.sprite.play("idle")

func PhysicsUpdate(delta: float) ->void:
	super.PhysicsUpdate(delta)
	if ray_cast_player.is_colliding():
		var collider = ray_cast_player.get_collider()
		if collider.is_in_group("player"):
			var player = collider
			if not player.is_player_invulnerable():
				TransitionState.emit("attack")
				#pass
