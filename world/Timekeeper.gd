extends Node


var current_tick_count := 0
var pregen_horizon := 60


var upcoming_actions := []


func _ready() -> void:
	$Ticker.wait_time = Global.tick_delta
	unpack_schedule()


func start() -> void:
	$Ticker.paused = false


func pause() -> void:
	$Ticker.paused = true


func _on_ticker_timeout() -> void:
	$Ticker.wait_time = Global.tick_delta
	EventBus.tick.emit()
	current_tick_count += 1

	handle_attack_music()
	handle_octopus_action()

	upcoming_actions.pop_front()

	if upcoming_actions.size() < pregen_horizon:
		unpack_schedule()
		

func unpack_schedule():
	while upcoming_actions.size() < pregen_horizon:
		var new_schedule = %OctopusAI.schedule_action()
		upcoming_actions.append_array(extract_actions_from_schedule(new_schedule))


func extract_actions_from_schedule(action_schedule: Dictionary) -> Array:
	var action_type = action_schedule.type
	var action_data = action_schedule.data

	var new_actions = []
	for i in range(action_schedule.duration):
		new_actions.append({type = action_type, data = action_data})
	
	return new_actions


func handle_octopus_action():
	match upcoming_actions[0].type:
		Global.OCTOPUS_ACTION.ATTACK_PLAYER:
			EventBus.octopus_attacked.emit(upcoming_actions[0])
		Global.OCTOPUS_ACTION.HEAL:
			EventBus.octopus_healed.emit(upcoming_actions[0])
		_:
			pass
			

func handle_attack_music():
	if upcoming_actions[Global.MUSIC_ANTICIPATION_WINDOW].type == Global.OCTOPUS_ACTION.ATTACK_PLAYER:
		EventBus.crossfade_music.emit()
