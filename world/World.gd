extends Node2D


var current_bubbles := 1000
var current_hp := Global.MAX_HP


func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    %BubbleCount.text = str(current_bubbles)


func heal(amount: int) -> void:
    current_hp = clamp(current_hp + amount, 0, 100)
    %HealthBar.value = current_hp
