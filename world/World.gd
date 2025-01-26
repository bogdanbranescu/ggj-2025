extends Node2D


var current_bubbles := 1000
var current_hp := 20#Global.MAX_HP


func _ready() -> void:
    $BGMPeaceful.play()

    $BGMAttack.volume_db = -80
    $BGMAttack.play()


func _process(_delta: float) -> void:
    %BubbleCount.text = str(current_bubbles)


func heal(amount: int) -> void:
    current_hp = clamp(current_hp + amount, 0, 100)
    %HealthBar.value = current_hp


func crossfade_music(from: AudioStreamPlayer2D, to: AudioStreamPlayer2D):
    var tween_fade_out = get_tree().create_tween()
    var tween_fade_in = get_tree().create_tween()

    tween_fade_out.tween_property(from, "volume_db", -80, 2)
    tween_fade_in.tween_property(to, "volume_db", 0, 2)
