extends Node2D


var current_bubbles := 1000
var current_hp := 20 # Global.MAX_HP


func _ready() -> void:
    $BGMAttack.volume_db = 0
    $BGMPeaceful.play()

    $BGMAttack.volume_db = -80
    $BGMAttack.play()


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


    tween_fade_out.tween_property(from, "volume_db", -80, 2)
    tween_fade_in.tween_property(to, "volume_db", 0, 2)


func checkIfCanSpawnClam() -> bool:
    var can_spawn = true;

    var rng = RandomNumberGenerator.new()
    rng.randomize()

    if rng.randi() % 2 == 0:
        can_spawn = false

    return can_spawn;
