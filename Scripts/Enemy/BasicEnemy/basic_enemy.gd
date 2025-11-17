class_name BasicEnemy
extends Enemy

@export var IDLE_SPEED: float = 50.0
@export var IDLE_ACCELERATION: float = 20.0

@onready var touch_hit_box: Area2D = $TouchHitBox

func _ready() -> void:
	if touch_hit_box and not touch_hit_box.body_entered.is_connected(_on_touch_hit_box_body_entered):
		touch_hit_box.body_entered.connect(_on_touch_hit_box_body_entered)


func _process(delta: float) -> void:
	if health <= 0:
		queue_free()


func _on_touch_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var _hitbox_direction: Vector2 = Vector2(1 if player.global_position.x-global_position.x > 0 else -1, 1)
		player.take_damage.emit(touch_damage, true, _hitbox_direction)
