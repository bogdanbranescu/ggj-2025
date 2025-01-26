extends Area2D


@onready var raycast_by_dir = {
	Vector2.UP: $RayCasts/RayCastUp,
	Vector2.LEFT: $RayCasts/RayCastLeft,
	Vector2.DOWN: $RayCasts/RayCastDown,
	Vector2.RIGHT: $RayCasts/RayCastRight
}

var type : int


func _ready() -> void:
	set_process(false)
	set_process_input(false)
	hide()


func _input(_event: InputEvent) -> void:
	var direction = Vector2.ZERO

	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT

	if direction != Vector2.ZERO and not raycast_by_dir[direction].is_colliding():
		position += direction * Global.TILE_SIZE

	if Input.is_action_just_pressed("confirm"):
		%StateChart.send_event("end_placement")

	if Input.is_action_just_pressed("cancel"):
		print("CURSOR CANCEL")
		%StateChart.send_event("go_to_shop")


func _on_placement_state_entered() -> void:
	set_process(true)
	set_process_input(true)
	show()


func _on_placement_state_exited() -> void:
	set_process(false)
	set_process_input(false)
	hide()


func set_type(cursor_type: int) -> void:
	type = cursor_type
	