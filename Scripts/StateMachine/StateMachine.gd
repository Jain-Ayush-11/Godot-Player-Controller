class_name StateMachine
extends Node

@export var initial_state: State

var _current_state: State

var states: Dictionary[String, State]


func _ready() -> void:
	for state in get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.TransitionState.connect(_on_state_transition_state)
	
	if initial_state:
		await get_tree().process_frame  # wait one frame for parent _ready() to finish for onready vars
		_current_state = initial_state
		_current_state.Enter()


func _process(delta: float) -> void:
	if _current_state:
		_current_state.Update(delta)


func _physics_process(delta: float) -> void:
	if _current_state:
		_current_state.PhysicsUpdate(delta)


func _on_state_transition_state(new_state_name: String) -> void:
	var new_state: State = states[new_state_name.to_lower()]
	if !new_state:
		return
	
	if _current_state:
		_current_state.Exit()
	
	await get_tree().process_frame  # wait one frame for parent _ready() to finish for onready vars
	new_state.Enter() 
	_current_state = new_state
