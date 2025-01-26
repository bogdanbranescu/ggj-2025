extends Node


var is_attacking := false
var health := 100



func _ready() -> void:
    get_tree().create_tween().tween_callback(attack).set_delay(12)


func take_damage():
    pass


func attack():
    get_parent().crossfade_music("attack")
    get_tree().create_tween().tween_callback(
        get_parent().crossfade_music.bind("peace")).set_delay(5)
