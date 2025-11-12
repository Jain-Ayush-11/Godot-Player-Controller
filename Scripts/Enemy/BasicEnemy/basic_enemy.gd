class_name BasicEnemy
extends Enemy

@export var IDLE_SPEED: float = 50.0
@export var IDLE_ACCELERATION: float = 20.0


func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
