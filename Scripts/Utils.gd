extends Node


func create_timer(wait_time: float, one_shot: bool = true, autostart: bool = false) -> Timer:
	var timer = Timer.new()

	timer.wait_time = wait_time
	timer.one_shot = one_shot
	timer.autostart = autostart

	return timer
