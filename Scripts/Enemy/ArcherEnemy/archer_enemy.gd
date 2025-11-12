class_name ArcherEnemy
extends Enemy

@export var IDLE_SPEED: float = 100.0
@export var IDLE_ACCELERATION: float = 20.0
@export var SHOOT_SPEED: float = 200.0
@export var SHOOT_DAMAGE: float = 10.0

var is_attacking: bool = false

func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
