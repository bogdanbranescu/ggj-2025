extends VBoxContainer


func _ready() -> void:
	set_process(false)
	set_process_input(false)


func _on_shop_state_entered() -> void:
	set_process(true)
	set_process_input(true)


func _on_shop_state_exited() -> void:
	print("BLA GOODBYE")
	set_process(false)
	set_process_input(false)


func _process(_delta: float) -> void:
	print("SHOP")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm"):
		pass

	if Input.is_action_just_pressed("cancel"):
		%StateChart.send_event("end_shop")
