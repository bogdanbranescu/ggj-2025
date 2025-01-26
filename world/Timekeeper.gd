extends Node


@export var tick_delta := 0.5
var current_tick_count := 0


func _ready() -> void:
	$Ticker.wait_time = tick_delta
	%AttackingInNumber.text = str(Global.TICKS_PER_PEACE_PHASE)


func start() -> void:
	$Ticker.paused = false


func pause() -> void:
	$Ticker.paused = true


func _on_ticker_timeout() -> void:
	#print("tick!")
	EventBus.tick.emit()
	current_tick_count += 1

	%AttackingInNumber.text = str(Global.TICKS_PER_PEACE_PHASE - current_tick_count)

	if current_tick_count >= Global.TICKS_PER_PEACE_PHASE:
		EventBus.octopus_attacked.emit()
		current_tick_count = 0
