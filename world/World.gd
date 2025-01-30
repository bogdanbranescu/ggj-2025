extends Node2D


var current_bubbles := 0:
	set(value):
		current_bubbles = value
		%BubbleCount.text = str(current_bubbles)
		EventBus.bubbles_changed.emit(current_bubbles)


var current_hp

var shake_offset := Vector2.ZERO
var is_shaking := false


func _ready() -> void:
	EventBus.octopus_attacked.connect(start_shaking_screen)

	$BGMAttack.volume_db = -30
	$BGMPeaceful.play()

	$BGMAttack.volume_db = -80
	$BGMAttack.play()

	current_hp = Global.MAX_HP
	update_health_bar()

	current_bubbles = 0

	%OctopusAI.set_strategy("basic")

	get_tree().paused = true


func _process(_delta: float) -> void:
	position = Vector2.ZERO
	if is_shaking:
		shake_screen()


func heal(amount: int) -> void:
	current_hp = clamp(current_hp + amount, 0, 100)


func update_health_bar() -> void:
	%HealthBar.value = current_hp
	%HealthBar/Text.text = str(current_hp) + "/" + str(Global.MAX_HP)


func playerTakeDamage(amount: int) -> void:
	current_hp = clamp(current_hp - amount, 0, 100)
	update_health_bar()


	if current_hp <= 0:
		%StateChart.send_event("go_to_lose_screen")


func crossfade_music(phase: String):
	match phase:
		"peace":
			get_tree().create_tween().tween_property($BGMAttack, "volume_db", -80, 3.0).set_trans(Tween.TRANS_EXPO)
			get_tree().create_tween().tween_property($BGMPeaceful, "volume_db", -30, 0.8)
		"attack":
			get_tree().create_tween().tween_property($BGMPeaceful, "volume_db", -80, 3.0).set_trans(Tween.TRANS_EXPO)
			get_tree().create_tween().tween_property($BGMAttack, "volume_db", -30, 0.8)
		_:
			print("Incorrect BGM crossfading destination!")


func checkIfCanSpawnClam() -> bool:
	var can_spawn = true;

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	if !rng.randi() % 3 == 0:
		can_spawn = false

	return can_spawn;


func start_shaking_screen():
	is_shaking = true
	get_tree().create_tween().tween_callback(
		func():
			is_shaking = false
	).set_delay(0.6)


func shake_screen():
	shake_offset = Vector2(randi() % 11 - 5, randi() % 11 - 5)
	position = shake_offset
