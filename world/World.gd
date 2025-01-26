extends Node2D


var current_bubbles := 1000
var current_hp := 20 # Global.MAX_HP


func _ready() -> void:
	$BGMAttack.volume_db = 0
	$BGMPeaceful.play()

	$BGMAttack.volume_db = -80
	$BGMAttack.play()

	current_hp = 100;
	%HealthBar.value = current_hp


func _process(_delta: float) -> void:
	%BubbleCount.text = str(current_bubbles)


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

	if rng.randi() % 4 == 0:
		can_spawn = false

	return can_spawn;
