extends Node


@export var tick_delta := 0.5

signal tick


func _ready() -> void:
	$Ticker.wait_time = tick_delta


func _on_ticker_timeout() -> void:
	print("tick!")
	tick.emit()
