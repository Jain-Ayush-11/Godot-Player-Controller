extends Node


static var RESOURCE_POOL: Dictionary[String, Array] = {}


func add_to_pool(pool_name: String, value: Object) -> void:
	value.visible = false
	if RESOURCE_POOL.has(pool_name):
		RESOURCE_POOL[pool_name].append(value)
	else:
		RESOURCE_POOL[pool_name] = [value]


func get_from_pool(pool_name: String) -> Object:
	var instance = RESOURCE_POOL[pool_name].pop_back()
	instance.visible = true
	return instance


func create_timer(wait_time: float, one_shot: bool = true, autostart: bool = false, name: String = "") -> Timer:
	var timer = Timer.new()

	timer.wait_time = wait_time
	timer.one_shot = one_shot
	timer.autostart = autostart
	
	if name != "":
		timer.name = name

	return timer


func get_or_create_node2D(name: String) -> Node2D:
	for child in get_tree().current_scene.get_children():
		if child.name == name:
			return child

	var new_node = Node2D.new()
	new_node.name = name
	get_tree().current_scene.add_child(new_node)
	return new_node
