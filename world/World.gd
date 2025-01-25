extends Node2D


var current_bubbles := 0
var current_hp := Global.MAX_HP


func _ready() -> void:
    pass


func _process(_delta: float) -> void:
    %BubbleCount.text = str(current_bubbles)
