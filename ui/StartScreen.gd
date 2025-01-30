extends Control


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm"):
		get_tree().paused = false
		%StateChart.send_event("go_to_swim")
		hide()
