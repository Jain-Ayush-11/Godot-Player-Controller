class_name BossState
extends State

var GRAVITY: float = 2000

var enemy: BossEnemy
static var player: Player

func Enter() -> void:
	enemy = get_parent().get_parent()	# State machine will always be a direct child of base node
	player = enemy.player


func _flip_enemy(direction: float) -> void:
	enemy.sprite.flip_h = true if direction < 0 else false
	enemy.is_facing_right = true if direction > 0 else false

	if direction < 0:
		enemy.ray_cast_player.target_position.x = -abs(enemy.ray_cast_player.target_position.x)
		enemy.ray_cast_ledge.position.x = -abs(enemy.ray_cast_ledge.position.x)
		enemy.sprite.offset.x = -abs(enemy.sprite.offset.x)
		enemy.attack_hit_box.scale.x = -1
	else:
		enemy.ray_cast_player.target_position.x = abs(enemy.ray_cast_player.target_position.x)
		enemy.ray_cast_ledge.position.x = abs(enemy.ray_cast_ledge.position.x)
		enemy.sprite.offset.x = abs(enemy.sprite.offset.x)
		enemy.attack_hit_box.scale.x = 1


func _apply_sprite_offset(value: float) -> void:
	enemy.sprite.offset.x = value if enemy.is_facing_right else -value
