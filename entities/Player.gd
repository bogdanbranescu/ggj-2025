extends CharacterBody2D


@onready var raycast_by_dir = {
	Vector2.UP: $RayCasts/RayCastUp,
	Vector2.LEFT: $RayCasts/RayCastLeft,
	Vector2.DOWN: $RayCasts/RayCastDown,
	Vector2.RIGHT: $RayCasts/RayCastRight
}


func _input(_event: InputEvent) -> void:
	var direction = Vector2.ZERO

	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
		$Sprite.flip_h = true
	
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
		$Sprite.flip_h = false

	if direction != Vector2.ZERO and not raycast_by_dir[direction].is_colliding():
		position += direction * Global.TILE_SIZE
