class_name BossEnemyWait
extends BossState

const SPEED: float = 50.0
const ACCELERATION: float = 10
@export var ATTACK_WAIT_TIME: float = 2
var wait_timer: Timer
var can_switch: bool = false


func Enter() -> void:
	super.Enter()
	print("\n\nWAITTT ", enemy.position)
	enemy.sprite.play("idle")

	
	if not wait_timer:
		wait_timer = Utils.create_timer(ATTACK_WAIT_TIME)
		add_child(wait_timer)
		wait_timer.timeout.connect(_on_wait_timer_timeout)

	wait_timer.start(randi_range(1, ATTACK_WAIT_TIME))


func PhysicsUpdate(delta: float) -> void:
	if can_switch and not player.is_player_invulnerable() and not PlayerState.is_dashing:
		TransitionState.emit("attack")
	enemy.direction = 1 if player.position.x > enemy.position.x else -1
	_flip_enemy(enemy.direction)


func _on_wait_timer_timeout() -> void:
	can_switch = true
