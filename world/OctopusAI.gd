extends Node


var is_attacking := false
var health := 100


func _ready() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, true)

	EventBus.octopus_attacked.connect(attack)

	%OctopusHealthBar.value = clamp(health, 0, 100)
	EventBus.octopus_take_damage.connect(handle_take_damage)


func attack():
	get_parent().crossfade_music("attack")
	get_tree().create_tween().tween_callback(
		get_parent().crossfade_music.bind("peace")).set_delay(5)


func handle_take_damage():
	health -= 3;
	%OctopusHealthBar.value = clamp(health, 0, 100)
	if health <= 0:
		pass ;
