extends VBoxContainer


func _ready() -> void:
	set_process(false)
	set_process_input(false)

	%ShopItemSelectorUI.hide()
	%ItemDescription.text = ""



func _on_shop_state_entered() -> void:
	set_process(true)
	set_process_input(true)

	get_children()[0].grab_focus()
	%ShopItemSelectorUI.show()


func _on_shop_state_exited() -> void:
	set_process(false)
	set_process_input(false)

	%ShopItemSelectorUI.hide()
	%ItemDescription.text = ""


func _process(_delta: float) -> void:
	pass


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm"):
		pass

	if Input.is_action_just_pressed("cancel"):
		%StateChart.send_event("end_shop")
