class_name ArcherEnemyAttack
extends EnemyState

const ARROW = preload("uid://cuck3p1mxyjwu")
const POOL_SIZE: int = 10


func _ready() -> void:
	_create_arrow_pool(POOL_SIZE)


func Enter() -> void:
	super.Enter()
	enemy.sprite.play("attack")


func PhysicsUpdate(delta: float) -> void:
	super.PhysicsUpdate(delta)
	if enemy.sprite.frame == 4 and not enemy.is_attacking:
		enemy.is_attacking = true
		_fire_arrow()
	if enemy.sprite.frame == 10:
		enemy.is_attacking = false
	if not ray_cast_player.is_colliding() and not enemy.is_attacking:
		TransitionState.emit("idle")


func Exit() -> void:
	enemy.is_attacking = false


func _fire_arrow() -> void:
	var arrow = Utils.get_from_pool(Constants.ARROW_POOL_KEY)

	arrow.position = enemy.global_position
	arrow.dir = 1 if enemy.is_facing_right else -1
	arrow.speed = enemy.SHOOT_SPEED
	arrow.damage = enemy.SHOOT_DAMAGE

	if not (arrow in get_tree().root.get_children()):
		get_tree().root.add_child(arrow)
	arrow._fire_arrow()



func _create_arrow_pool(pool_size: int) -> void:
	for i in range(pool_size):
		var arrow = ARROW.instantiate()
		Utils.add_to_pool(Constants.ARROW_POOL_KEY, arrow)
