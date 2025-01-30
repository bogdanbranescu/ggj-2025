extends Node



var is_attacking := false
var health := 100

var strategies = {
	basic = strategy_basic,
	other_etc = strategy_other_etc,
}

var current_strategy := strategy_basic
var planning_horizon := 1  # maybe usable to make the Octopus commit to a strategy for a time
var action_queue = []


func _ready() -> void:
	# var bus_idx = AudioServer.get_bus_index("Master")
	# AudioServer.set_bus_mute(bus_idx, true)

	EventBus.crossfade_music.connect(crossfade_music)
	EventBus.octopus_attacked.connect(attack)
	EventBus.octopus_healed.connect(heal.bind(30))	# TODO make this work with any value

	%OctopusHealthBar.value = clamp(health, 0, 100)
	EventBus.octopus_take_damage.connect(handle_take_damage)


func attack():
	%OctopusSprite.frame = 0
	get_tree().create_tween().tween_callback(func(): %OctopusSprite.frame = 1).set_delay(1.0)


func heal(amount: int):
	health = clamp(health + amount, 0, 100)
	%OctopusHealthBar.value = health


func crossfade_music():
	get_parent().crossfade_music("attack")
	get_tree().create_tween().tween_callback(
		get_parent().crossfade_music.bind("peace")).set_delay(4.0)


func handle_take_damage(amount := Global.BULLET_DAMAGE):
	health = clamp(health - amount, 0, 100)
	%OctopusHealthBar.value = health
	if health <= 0:
		%StateChart.send_event("go_to_win_screen")


func choose_action(action_type: int, after_ticks: int, action_data: Dictionary={}) -> void:
	action_queue.append_array([
		{type = Global.OCTOPUS_ACTION.IDLE, duration = after_ticks - 1, data = {}},
		{type = action_type as Global.OCTOPUS_ACTION, duration = 1, data = action_data},
	])


func schedule_action() -> Dictionary:
	if action_queue.size() < planning_horizon:
		run_strategy(current_strategy)
	return action_queue.pop_front()


func set_strategy(strategy_name: String) -> void:
	run_strategy(strategies[strategy_name])


func run_strategy(strategy: Callable):
	strategy.call()


func strategy_basic():
	if health <= 30 and randi():
		choose_action(Global.OCTOPUS_ACTION.HEAL, 20)
	elif health <= 60 and randi() % 4 != 0:
		choose_action(Global.OCTOPUS_ACTION.HEAL, 30)
	else:
		choose_action(Global.OCTOPUS_ACTION.ATTACK_PLAYER, 30)


func strategy_other_etc():
	pass


# for more advanced rescheduling (e.g. interrupt current strategy)
func recompute_strategy():
	pass