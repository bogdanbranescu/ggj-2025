extends Area2D


@onready var raycast_by_dir = {
	Vector2.UP: $RayCasts/RayCastUp,
	Vector2.LEFT: $RayCasts/RayCastLeft,
	Vector2.DOWN: $RayCasts/RayCastDown,
	Vector2.RIGHT: $RayCasts/RayCastRight
}

var type: int
var cost_of_type: int;
var initial_position := position

@onready var world = get_node(Global.world_path)
@onready var tilemap = %TileMapEntities as TileMapLayer


func _ready() -> void:
	toggle_behavior(false)


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

	if direction != Vector2.ZERO:
		var next_position = tilemap.local_to_map(self.position + direction * Global.TILE_SIZE)
		if next_position.x == clamp(next_position.x, 2, 15) and next_position.y == clamp(next_position.y, 2, 11):
			position += direction * Global.TILE_SIZE

	if Input.is_action_just_pressed("confirm"):
		match type:
			Global.ITEM_TYPE.SHOVEL:
				dig()
			Global.ITEM_TYPE.COLLECTOR:
				place_item()
			Global.ITEM_TYPE.SHOOTER:
				place_item()
	
	if Input.is_action_just_pressed("cancel"):
		toggle_behavior(false)
		world.current_bubbles += cost_of_type
		%StateChart.send_event("go_to_shop")

	adjust_icon()


func _on_placement_state_entered() -> void:
	toggle_behavior(true)


func _on_placement_state_exited() -> void:
	toggle_behavior(false)


func toggle_behavior(value: bool) -> void:
		set_process(value)
		set_process_input(value)

		position = initial_position

		if value:
			show()
		else:
			hide()


func set_type(cursor_type: int, price: int) -> void:
	type = cursor_type
	cost_of_type = price
	adjust_icon()


func adjust_icon():
	var map_position = tilemap.local_to_map(self.position)
	if is_current_item_placeable(map_position):
		$Sprite.frame = type
	else:
		$Sprite.frame = type + 4


func dig():
	var map_position = tilemap.local_to_map(self.position)
	if not is_current_item_placeable(map_position):
		return

	tilemap.remove_tile(map_position)
	$SFX.play()
	EventBus.price_increased.emit(type)
	%StateChart.send_event("end_placement")

	if world.checkIfCanSpawnClam():
		tilemap.place_tile(map_position, Global.TILE_TYPE.SHELL)
	else:
		tilemap.place_tile(map_position, Global.TILE_TYPE.BUBBLE)


func place_item():
	var map_position = tilemap.local_to_map(self.position)
	if not is_current_item_placeable(map_position):
		return
	
	tilemap.place_tile(map_position, type)
	$SFX.play()
	EventBus.price_increased.emit(type)
	%StateChart.send_event("end_placement")
	

func is_current_item_placeable(map_position: Vector2i) -> bool:
	var cell_data = tilemap.get_cell_tile_data(map_position)
	var cell_data_above = tilemap.get_cell_tile_data(map_position + Vector2i.UP)
	var cell_data_below = tilemap.get_cell_tile_data(map_position + Vector2i.DOWN)
	
	var is_sand = cell_data and cell_data.get_custom_data("is_sand")
	var has_sand_above = cell_data_above and cell_data_above.get_custom_data("is_sand")
	var has_sand_below = cell_data_below and cell_data_below.get_custom_data("is_sand")
	
	var shell_id = 3 # uses alternative_tile in Scene Collections
	var tile_type_above = tilemap.get_cell_alternative_tile(map_position + Vector2i.UP)
	var has_shell_above = tile_type_above == shell_id
	
	var tile_type_below = tilemap.get_cell_alternative_tile(map_position + Vector2i.DOWN)
	var has_shell_below = tile_type_below == shell_id
	
	match type:
		Global.ITEM_TYPE.SHOVEL:
			return is_sand and not has_sand_above && !has_shell_above

		Global.ITEM_TYPE.COLLECTOR:
			return !is_sand and !has_sand_below and !has_shell_below

		Global.ITEM_TYPE.SHOOTER:
			return !is_sand and !has_sand_below and !has_shell_below

	return true
