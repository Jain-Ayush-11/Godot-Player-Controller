class_name PlayerDash
extends PlayerState

const PLAYER_DASH_IMAGE: PackedScene = preload(Constants.PLAYER_AFTER_IMAGE_SCENE_PATH)
const DASH_IMAGE_TIME: float = 0.15
const PLAYER_DASH_TIME: float = 0.15
const AFTER_IMAGE_SPAWN_TIME: float = 0.0025

var dash_timer: Timer

var player_dash_after_images_parent: Node2D
var player_dash_image_pool: Array
var time_left_for_next_image: float = 0.0

func Enter() -> void:
	super.Enter()
	is_invulnerable = true
	dash_left -= 1
	if get_children().size() > 0:
		dash_timer = get_child(0)
	
	if not dash_timer or dash_timer is not Timer:
		dash_timer = Utils.create_timer(PLAYER_DASH_TIME)
		add_child(dash_timer)
		dash_timer.timeout.connect(_on_dash_timer_timeout)

	dash_timer.start()
	is_dashing = true
	player_sprite.play("dash")
	
	player_dash_after_images_parent = Utils.get_or_create_node2D("player_dash_after_images_parent")
	player_dash_after_images_parent.visible = true

	player_dash_image_pool = player_dash_after_images_parent.get_children()
	_add_images_to_pool()

func PhysicsUpdate(delta: float) ->void:
	if is_dashing:
		var direction = 1 if is_player_facing_right else -1
		player.velocity.x = direction * player.DASH_SPEED
		player.velocity.y = 0
		_spawn_trail(delta)
		player.move_and_slide()
	else:
		TransitionState.emit("idle")

func Exit() -> void:
	player_dash_after_images_parent.visible = false
	is_invulnerable = false

func _on_dash_timer_timeout() -> void:
	is_dashing = false

func _add_images_to_pool() -> void:
	var image_count_to_add: int
	if player_dash_image_pool.size() < Constants.PLAYER_DASH_AFTER_IMAGE_POOL_SIZE:
		image_count_to_add = Constants.PLAYER_DASH_AFTER_IMAGE_POOL_SIZE - player_dash_image_pool.size()

	for i in range(image_count_to_add):
		var instance = PLAYER_DASH_IMAGE.instantiate()
		instance.visible = false
		player_dash_after_images_parent.add_child(instance)
		player_dash_image_pool.append(instance)

func _spawn_trail(delta: float):
	time_left_for_next_image -= delta
	if time_left_for_next_image <= 0 and dash_timer.time_left > AFTER_IMAGE_SPAWN_TIME:
		var tween = create_tween()
		time_left_for_next_image = AFTER_IMAGE_SPAWN_TIME
		var after_image: Node2D = player_dash_image_pool.pop_back()
		if after_image:
			after_image.visible = true
			after_image.global_position = player.global_position
			after_image.modulate.a = 1
			var after_image_sprite = after_image.get_child(0)
			after_image_sprite.flip_h = player_sprite.flip_h
			tween.tween_property(after_image, "modulate:a", 0, DASH_IMAGE_TIME)
