extends BossEnemyAttack

@export var Slash_Attack_Damage: float = 20.0

func Enter() -> void:
	print("SLASSHHHH")
	super.Enter()
	enemy.sprite.play("slashattack")
	enemy.damage = Slash_Attack_Damage


func PhysicsUpdate(delta: float) -> void:
	if enemy.sprite.frame == hit_start_frame:
		attack_hit_box.disabled = false
	
	if enemy.sprite.frame == hit_start_end:
		attack_hit_box.disabled = true
	
	if not enemy.sprite.is_playing():
		TransitionState.emit("waitattack")


func Exit() -> void:
	enemy.damage = 0
