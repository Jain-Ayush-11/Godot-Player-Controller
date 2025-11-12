class_name ArcherEnemyIdle
extends EnemyIdle

func Enter() -> void:
	super.Enter()

func PhysicsUpdate(delta: float) -> void:
	super.PhysicsUpdate(delta)
	enemy.velocity.x = move_toward(enemy.velocity.x, enemy.direction*enemy.IDLE_SPEED, enemy.IDLE_ACCELERATION)
	enemy.velocity.y += GRAVITY * delta
	enemy.move_and_slide()
