extends RigidBody2D

const GROUND_STICK_ANGLE: float = 21.0

@export var speed: float = 200.0
@export var damage: float = 10.0
@export var stick_depth: float = 6

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ray_cast_wall2: RayCast2D = $RayCastWall2
@onready var ray_cast_wall: RayCast2D = $RayCastWall
@onready var disappear_timer: Timer = $DisappearTimer

var is_stuck: bool = false
var initial_pos: Vector2
var dir: float = 1.0
var gravity: float = 0.2


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	disappear_timer.timeout.connect(_on_disappear_timer_timeout)


func _physics_process(delta: float) -> void:
	if not is_stuck and linear_velocity.length() > 0.1:
		rotation = linear_velocity.angle()


func _on_body_entered(body: Node) -> void:
	is_stuck = true
	if body.is_in_group("player"):
		body.take_damage.emit(damage, false)
		Utils.add_to_pool(Constants.ARROW_POOL_KEY, self)
	else:
		rotation_degrees = GROUND_STICK_ANGLE if dir > 0 else 180-GROUND_STICK_ANGLE
		is_stuck = true
		gravity_scale = 0
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		call_deferred("_stick_to_ground")


func get_wall_stick_position(x: float, y: float) -> float:
	# equation of linear motion in 2d plane
	return -((gravity*(stick_depth*(x-initial_pos.x)+((stick_depth*stick_depth)/2)))/(speed*speed))


func _stick_to_ground() -> void:
	if ray_cast_wall.is_colliding() or ray_cast_wall2.is_colliding():
		position += Vector2(dir *stick_depth, stick_depth/4)
	collision_shape_2d.disabled = true
	sprite.play("secondary")
	freeze = true
	disappear_timer.start()


func _on_disappear_timer_timeout() -> void:
	Utils.add_to_pool(Constants.ARROW_POOL_KEY, self)


func _fire_arrow() -> void:
	freeze = false
	is_stuck = false
	collision_shape_2d.disabled = false

	sprite.play("primary")
	linear_velocity.x = dir*speed
	linear_velocity.y = 0
	initial_pos = position
	gravity_scale = gravity
