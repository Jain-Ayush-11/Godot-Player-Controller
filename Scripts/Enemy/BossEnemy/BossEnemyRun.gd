class_name BossEnemyRun
extends BossState

const ACCELERATION: float = 10

@export var SPEED: float = 100.0
@export var SPRITE_OFFSET: float = 20.0

func Enter() -> void:
	super.Enter()
	print("RUNNN ", enemy.position, " ", player.position)
	if player.position.x > enemy.position.x:
		enemy.direction = 1
	elif player.position.x < enemy.position.x:
		enemy.direction = -1
	_flip_enemy(enemy.direction)
	_apply_sprite_offset(SPRITE_OFFSET)
	enemy.sprite.play("run")


func PhysicsUpdate(delta: float) ->void:
	if enemy.ray_cast_player.is_colliding() and not player.is_player_invulnerable():
		TransitionState.emit("attack")

	if player.position.x > enemy.position.x:
		enemy.direction = 1
	elif player.position.x < enemy.position.x:
		enemy.direction = -1
	_flip_enemy(enemy.direction)
	print("\n\nRUNNN ", enemy.position, " ", player.position, " ", enemy.direction)
	#enemy.velocity.x = move_toward(enemy.velocity.x, enemy.direction*SPEED, ACCELERATION)
	enemy.velocity.y += GRAVITY * delta
	#enemy.move_and_slide()


func Exit() -> void:
	_apply_sprite_offset(0)
