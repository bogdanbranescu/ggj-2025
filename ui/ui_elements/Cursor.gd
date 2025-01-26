extends Area2D


@onready var raycast_by_dir = {
	Vector2.UP: $RayCasts/RayCastUp,
	Vector2.LEFT: $RayCasts/RayCastLeft,
	Vector2.DOWN: $RayCasts/RayCastDown,
	Vector2.RIGHT: $RayCasts/RayCastRight
}

var type: int

@onready var world = get_node(Global.world_path)

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

	if direction != Vector2.ZERO:
		var next_position = %TileMapEntities.local_to_map(self.position + direction * Global.TILE_SIZE)
		if next_position.x == clamp(next_position.x, 2, 15) and next_position.y == clamp(next_position.y, 2, 11):
			position += direction * Global.TILE_SIZE

	if Input.is_action_just_pressed("confirm"):
		match type:
			Global.ITEM_TYPE.SHOVEL:
				dig()
				$SFX.play()
	
			Global.ITEM_TYPE.COLLECTOR:
				place_collector()
				$SFX.play()
		
			Global.ITEM_TYPE.SHOOTER:
				place_shooter()
				$SFX.play()
	
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
	$Sprite.frame = type


func dig():
	var tileMapEnts: TileMapLayer = %TileMapEntities;

	var map_position = tileMapEnts.local_to_map(self.position)
	var cell_data = tileMapEnts.get_cell_tile_data(map_position)
	var cell_data_above = tileMapEnts.get_cell_tile_data(map_position + Vector2i.UP)

	var is_sand = cell_data and cell_data.get_custom_data("is_sand")
	var has_sand_above = cell_data_above and cell_data_above.get_custom_data("is_sand")
	

	var currentCellId = tileMapEnts.get_cell_source_id(map_position + Vector2i.UP);
	print("currentCellId: ", currentCellId);
	var shell_id = 0;
	var has_clam_at_top = currentCellId == shell_id;

	if is_sand and not has_sand_above && !has_clam_at_top:
		tileMapEnts.remove_tile(map_position)
		%StateChart.send_event("end_placement")

		if world.checkIfCanSpawnClam():
			tileMapEnts.place_tile(map_position, Global.TILE_TYPE.SHELL)
		else:
			tileMapEnts.place_tile(map_position, Global.TILE_TYPE.BUBBLE)


func place_shooter():
	var map_position = %TileMapEntities.local_to_map(self.position)
	var cell_data = %TileMapEntities.get_cell_tile_data(map_position)
	var is_sand = cell_data and cell_data.get_custom_data("is_sand")

	if not is_sand:
		%TileMapEntities.place_tile(map_position, Global.TILE_TYPE.SHOOTER)
		%StateChart.send_event("end_placement")


func place_collector():
	var map_position = %TileMapEntities.local_to_map(self.position)
	var cell_data = %TileMapEntities.get_cell_tile_data(map_position)
	var is_sand = cell_data and cell_data.get_custom_data("is_sand")

	if not is_sand:
		%TileMapEntities.place_tile(map_position, Global.TILE_TYPE.COLLECTOR)
		%StateChart.send_event("end_placement")
