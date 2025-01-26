extends Node2D


var current_bubbles := 0
var current_hp := 100 # Global.MAX_HP

var shake_offset := Vector2.ZERO
var is_shaking := false


func _ready() -> void:
	EventBus.octopus_attacked.connect(start_shaking_screen)

	$BGMAttack.volume_db = 0
	$BGMPeaceful.play()

	$BGMAttack.volume_db = -80
	$BGMAttack.play()

	current_hp = 100;
	%HealthBar.value = current_hp


func _process(_delta: float) -> void:
	%BubbleCount.text = str(current_bubbles)

	if is_shaking:
		shake_screen()
		get_tree().create_tween().tween_property($BGMAttack, "volume_db", -80, 4)


func heal(amount: int) -> void:
	current_hp = clamp(current_hp + amount, 0, 100)
	%HealthBar.value = current_hp

func playerTakeDamage(amount: int) -> void:
	current_hp = clamp(current_hp - amount, 0, 100)
	%HealthBar.value = current_hp

	if current_hp <= 0:
		%StateChart.send_event("go_to_lose_screen")

func crossfade_music(phase: String):
	match phase:
		"peace":
			get_tree().create_tween().tween_property($BGMAttack, "volume_db", -80, 4)
			get_tree().create_tween().tween_property($BGMPeaceful, "volume_db", 0, 0.5)
		"attack":
			get_tree().create_tween().tween_property($BGMPeaceful, "volume_db", -80, 4)
			get_tree().create_tween().tween_property($BGMAttack, "volume_db", 0, 0.5)
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
			shake_offset = Vector2.ZERO
	).set_delay(0.6)


func shake_screen():
	shake_offset = Vector2(randi() % 11 - 5, randi() % 11 - 5)
	position = shake_offset
