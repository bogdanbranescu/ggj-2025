extends Node


signal attacked

enum ACTION {
	IDLE,
	ATTACK_PLAYER,
	ATTACK_OBJECT,
	HEAL
}

var is_attacking := false
var health := 100

var action_queue = [
	{type = ACTION.IDLE, duration = 19, data = {}},
	{type = ACTION.ATTACK_PLAYER, duration = 1, data = {}},
	{type = ACTION.IDLE, duration = 14, data = {}},
	{type = ACTION.HEAL, duration = 1, data = {}},
]


func _ready() -> void:
	# var bus_idx = AudioServer.get_bus_index("Master")
	# AudioServer.set_bus_mute(bus_idx, true)

	EventBus.crossfade_music.connect(crossfade_music)
	EventBus.octopus_attacked.connect(attack)

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


func schedule_action(action_type: int, after_ticks: int, action_data: Dictionary={}) -> void:
	action_queue.append_array([
		{type = ACTION.IDLE, duration = after_ticks - 1, data = {}},
		{type = action_type as ACTION, duration = 1, data = action_data},
	])


func send_action() -> Array:
	return action_queue.pop_front()


func run_strategy(strategy: Callable):
	strategy.call()


func strategy_basic():
	if health <= 50 and randi() % 4 != 0:
		schedule_action(ACTION.HEAL, 15)
	elif health <= 30 and randi() % 2 != 0:
		schedule_action(ACTION.HEAL, 10)
	else:
		schedule_action(ACTION.ATTACK_PLAYER, 20)


func strategy_other_etc():
	pass
