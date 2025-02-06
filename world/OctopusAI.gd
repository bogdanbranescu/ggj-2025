extends Node


var is_attacking := false
var health := 100

var strategies = {
	conditional_basic = strategy_conditional_basic,
	incremental_deterministic_a = strategy_incremental_deterministic_a,
	other_etc = strategy_other_etc,
}

var current_strategy := strategy_incremental_deterministic_a
var planning_horizon := 1 # maybe usable to make the Octopus commit to a strategy for a time
var action_queue = []

var run_strategy_count := 0


func _ready() -> void:
	# var bus_idx = AudioServer.get_bus_index("Master")
	# AudioServer.set_bus_mute(bus_idx, true)

	EventBus.octopus_attacked.connect(attack)
	EventBus.octopus_healed.connect(heal)

	%OctopusHealthBar.value = clamp(health, 0, 100)
	EventBus.octopus_take_damage.connect(handle_take_damage)


func attack(_data = {}):
	%OctopusSprite.frame = 0
	get_tree().create_tween().tween_callback(func(): %OctopusSprite.frame = 1).set_delay(1.0)


func heal(data):
	health = clamp(health + data.data.amount, 0, 100)
	%OctopusHealthBar.value = health
	
	%OctopusHealingAnimation.play()


func handle_take_damage(data = {amount = Global.BULLET_DAMAGE}):
	health = clamp(health - data.amount, 0, 100)
	%OctopusHealthBar.value = health
	if health <= 0:
		%StateChart.send_event("go_to_win_screen")


func choose_action(action_type: int, after_ticks: int, action_data: Dictionary) -> void:
	action_queue.append_array([
		{type = Global.OCTOPUS_ACTION.IDLE, duration = after_ticks - 1, data = {amount = 0}},
		{type = action_type as Global.OCTOPUS_ACTION, duration = 1, data = action_data},
	])


func schedule_action() -> Dictionary:
	if action_queue.size() < planning_horizon:
		run_strategy(current_strategy)
	return action_queue.pop_front()


func set_strategy(strategy_name: String) -> void:
	current_strategy = strategies[strategy_name]


func run_strategy(strategy: Callable):
	strategy.call()
	run_strategy_count += 1


func strategy_incremental_deterministic_a():
	var intensity = 1 + floor(run_strategy_count / 6.0) # increases every 2 cycles (as described below)
	var clamped_intensity = clamp(intensity, 1, 8)

	match run_strategy_count % 3:
		0:
			var time_before_action = (16 - clamped_intensity) * 2
			var action_data = {amount = clamped_intensity * 2}
			choose_action(Global.OCTOPUS_ACTION.ATTACK_PLAYER, time_before_action, action_data)
		1:
			var time_before_action = (16 - clamped_intensity) * 2
			var action_data = {amount = clamped_intensity * 2}
			choose_action(Global.OCTOPUS_ACTION.ATTACK_PLAYER, time_before_action, action_data)
		2:
			var time_before_action = (16 - clamped_intensity) * 2
			var action_data = {amount = clamped_intensity * 5}
			choose_action(Global.OCTOPUS_ACTION.HEAL, time_before_action, action_data)


func strategy_conditional_basic():
	if health <= 30 and randi():
		choose_action(Global.OCTOPUS_ACTION.HEAL, 20, {amount = Global.OCTOPUS_HEAL_AMOUNT})
	elif health <= 60 and randi() % 4 != 0:
		choose_action(Global.OCTOPUS_ACTION.HEAL, 30, {amount = Global.OCTOPUS_HEAL_AMOUNT})
	else:
		choose_action(Global.OCTOPUS_ACTION.ATTACK_PLAYER, 30, {amount = Global.DAMAGE_PER_OCTOPUS_HIT})


func strategy_other_etc():
	pass


# for more advanced rescheduling (e.g. interrupt current strategy)
func recompute_strategy():
	pass