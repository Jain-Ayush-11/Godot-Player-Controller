extends Node2D


@export var health: float = 20
@export var damage: float = 20

@onready var player: Player = %Player
@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.attack_hit.connect(on_player_attack_hit)
	area_2d.body_entered.connect(_on_area_2d_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		print("DEAD")

func on_player_attack_hit(body: Node2D, damage: float):
	if body == self:
		health -= damage

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player.take_damage.emit(damage)
