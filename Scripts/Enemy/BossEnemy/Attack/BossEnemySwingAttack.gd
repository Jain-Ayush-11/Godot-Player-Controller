extends BossEnemyAttack

@export var DASH_SPEED: float = 1000.0
@export var Swing_Attack_Damage: float = 30
@export var WAIT_TIME: float = 0.2
@export var MAX_DASH_TIME: float = 1

static var count: int = 0

var dash_timer: Timer
var attack_wait_timer: Timer
var player_pos: Vector2

var is_dashing: bool = false


func _ready() -> void:
	if not attack_wait_timer:
		attack_wait_timer = Utils.create_timer(WAIT_TIME)
		attack_wait_timer.timeout.connect(on_attack_wait_timer_timeout)
		add_child(attack_wait_timer)

	if not dash_timer:
		dash_timer = Utils.create_timer(MAX_DASH_TIME)
		dash_timer.timeout.connect(on_dash_timer_timeout)
		add_child(dash_timer)


func Enter() -> void:
	count += 1
	print("ENTERED")
	super.Enter()
	if player.is_player_invulnerable():
		TransitionState.emit("waitattack")
	
	enemy.sprite.play("swingattackposture")
	enemy.damage = Swing_Attack_Damage
	attack_wait_timer.start()
	player_pos = player.position


func PhysicsUpdate(delta: float) -> void:
	if is_dashing:
		_dash()

	else:
		if enemy.sprite.frame == hit_start_frame and enemy.sprite.animation == "swingattack":
			attack_hit_box.disabled = false
		
		if enemy.sprite.frame == hit_start_end and enemy.sprite.animation == "swingattack":
			attack_hit_box.disabled = true
		
		if not enemy.sprite.is_playing() and enemy.sprite.animation == "swingattack":
			TransitionState.emit("waitattack")


func Exit() -> void:
	print("DUNZOOOO")
	enemy.damage = 0


func on_attack_wait_timer_timeout() -> void:
	var dash_time: float = calculate_dash_time()
	if dash_time > 0.0:
		dash_timer.start(0.1)
		is_dashing = true
	else:
		on_dash_timer_timeout()


func on_dash_timer_timeout() -> void:
	is_dashing = false
	print("DASH_END")
	enemy.sprite.play("swingattack")


func _dash() -> void:
	var dash_dir: int = 1 if player.position.x > enemy.position.x else -1
	enemy.velocity.x = dash_dir * DASH_SPEED
	print("DASH_START")
	enemy.move_and_slide()


func calculate_dash_time() -> float:
	var distance: float = abs(enemy.position.x - player.position.x)-50
	var dash_time = distance/DASH_SPEED
	return dash_time
