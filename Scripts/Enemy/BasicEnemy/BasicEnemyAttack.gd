class_name BasicEnemyAttack
extends EnemyState

var SPEED: float = 150.0
const ACCELERATION: float = 10

func Enter() -> void:
	super.Enter()
	enemy.sprite.play("idle")
	enemy.sprite.speed_scale = 2.5
	enemy.move_and_slide()


func PhysicsUpdate(delta: float) ->void:
	var collision = enemy.get_last_slide_collision()
	if collision.get_collider().is_in_group("player"):
		var player = collision.get_collider()
		var _hitbox_direction: Vector2 = Vector2(1 if player.global_position.x-enemy.global_position.x > 0 else -1, 1)
		player.take_damage.emit(enemy.damage, true, _hitbox_direction)
		TransitionState.emit("idle")
	if not ray_cast_player.is_colliding():
		TransitionState.emit("idle")
	else:
		var collider = ray_cast_player.get_collider()
		if not collider.is_in_group("player"):
			TransitionState.emit("idle")

	enemy.velocity.x = move_toward(enemy.velocity.x, enemy.direction*SPEED, ACCELERATION)
	enemy.velocity.y += GRAVITY * delta
	enemy.move_and_slide()
