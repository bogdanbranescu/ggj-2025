extends Node


var is_attacking := false
var health := 100


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


func crossfade_music():
	get_parent().crossfade_music("attack")
	get_tree().create_tween().tween_callback(
		get_parent().crossfade_music.bind("peace")).set_delay(6.0)


func handle_take_damage():
	health -= Global.BULLET_DAMAGE;
	%OctopusHealthBar.value = clamp(health, 0, 100)
	if health <= 0:
		pass ;
