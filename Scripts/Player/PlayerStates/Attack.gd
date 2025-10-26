class_name PlayerAttack
extends PlayerState

var _primary_attack_hit_box: CollisionShape2D
var _secondary_attack_hit_box: CollisionShape2D

var _is_primary_attack: bool = true
var attack_combo_timer: Timer


func _ready() -> void:
	attack_combo_timer = Utils.create_timer(Constants.PLAYER_ATTACK_COMBO_TIMER)
	add_child(attack_combo_timer)


func Enter() -> void:
	super.Enter()
	player_normal_collision_shape.disabled = true
	player_attack_collision_shape.disabled = false

	if not player_sprite.animation_finished.is_connected(_on_player_sprite_animation_finished):
		player_sprite.animation_finished.connect(_on_player_sprite_animation_finished)

	if not attack_hit_box_area.body_entered.is_connected(_on_attack_hit_box_area_body_entered):
		attack_hit_box_area.body_entered.connect(_on_attack_hit_box_area_body_entered)
	
	for collision_shape in attack_hit_box_area.get_children():
		if collision_shape is CollisionShape2D:
			match collision_shape.name:
				"PrimaryAttack":
					_primary_attack_hit_box = collision_shape
				"SecondaryAttack":
					_secondary_attack_hit_box = collision_shape

	if not attack_combo_timer.is_stopped():
		player_sprite.play("attack_secondary")
		_primary_attack_hit_box.disabled = true
		_secondary_attack_hit_box.disabled = false
	else:
		player_sprite.play("attack_primary")
		_is_primary_attack = true
		_primary_attack_hit_box.disabled = false
		_secondary_attack_hit_box.disabled = true


func Exit() -> void:
	player_normal_collision_shape.disabled = false
	player_attack_collision_shape.disabled = true
	_primary_attack_hit_box.disabled = true
	_secondary_attack_hit_box.disabled = true
	
	if attack_combo_timer.is_stopped() and _is_primary_attack:
		attack_combo_timer.start()
	else:
		attack_combo_timer.stop()
	_is_primary_attack = false


func _on_player_sprite_animation_finished() -> void:
	TransitionState.emit("idle")


func _on_attack_hit_box_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("damagable"):
		player.attack_hit.emit(body, player.PRIMARY_ATTACK_POWER)
