class_name BasicEnemyIdle
extends EnemyIdle

func Enter() -> void:
	super.Enter()
	enemy.sprite.speed_scale = 1

func PhysicsUpdate(delta: float) ->void:
	super.PhysicsUpdate(delta)
	enemy.velocity.x = move_toward(enemy.velocity.x, enemy.direction*enemy.IDLE_SPEED, enemy.IDLE_ACCELERATION)
	enemy.velocity.y += GRAVITY * delta
	enemy.move_and_slide()
