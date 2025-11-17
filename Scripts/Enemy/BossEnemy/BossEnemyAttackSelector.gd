extends BossState

@export var long_range_attacks: Array[BossEnemyAttack] = []
@export var close_range_attacks: Array[BossEnemyAttack] = []
@export var long_range_second_phase_break: int
@export var close_range_second_phase_break: int
@export var range_threshold: float = 62.5

var current_attack: int = 0

func Enter() -> void:
	super.Enter()
	print("\n\nSELECT ", enemy.position, " ", player.position)
	
	if enemy.ray_cast_player.is_colliding() and not player.is_player_invulnerable() and not PlayerState.is_dashing:
		#if abs(player.position.x - enemy.position.x) > range_threshold:
		TransitionState.emit(long_range_attacks[randi_range(0, long_range_attacks.size()-1)].name)
		#else:
			#TransitionState.emit(close_range_attacks[randi_range(0, close_range_attacks.size()-1)].name)
	else:
		TransitionState.emit("run")
