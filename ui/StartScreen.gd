extends Control


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm"):	# WARNING confirm is considered "just pressed"
												# when unpausing and going to the Swim state
		get_tree().paused = false
		%StateChart.send_event("go_to_swim")
		hide()
