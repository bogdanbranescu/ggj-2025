extends Area2D


var type := "bubble"


func _ready() -> void:
	EventBus.tick.connect(tick_update)


func tick_update() -> void:
	pass