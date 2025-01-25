extends Node


@export var tick_delta := 0.5


func _ready() -> void:
	$Ticker.wait_time = tick_delta
	#pause()


func start() -> void:
	$Ticker.paused = false


func pause() -> void:
	$Ticker.paused = true


func _on_ticker_timeout() -> void:
	print("tick!")
	EventBus.tick.emit()
