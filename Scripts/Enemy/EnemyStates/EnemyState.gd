class_name EnemyState
extends State

static var GRAVITY: float = 2000

var enemy: Enemy
var ray_cast_player: RayCast2D

func Enter() -> void:
	enemy = get_parent().get_parent()	# State machine will always be a direct child of base node
	ray_cast_player = enemy.ray_cast_player

func PhysicsUpdate(delta: float) ->void:
	if enemy.ray_cast_right.is_colliding():
		enemy.direction = -1
		_flip_enemy(enemy.direction)
	if enemy.ray_cast_left.is_colliding():
		enemy.direction = 1
		_flip_enemy(enemy.direction)
	if not enemy.ray_cast_ledge.is_colliding():
		enemy.direction = -enemy.direction
		_flip_enemy(enemy.direction)

func _flip_enemy(direction: float) -> void:
	enemy.sprite.flip_h = true if direction < 0 else false
	enemy.is_facing_right = true if direction > 0 else false

	if direction < 0:
		enemy.ray_cast_player.target_position.x = -abs(enemy.ray_cast_player.target_position.x)
		enemy.ray_cast_ledge.position.x = -abs(enemy.ray_cast_ledge.position.x)
	else:
		enemy.ray_cast_player.target_position.x = abs(enemy.ray_cast_player.target_position.x)
		enemy.ray_cast_ledge.position.x = abs(enemy.ray_cast_ledge.position.x)
