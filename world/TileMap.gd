extends TileMapLayer


var scene_coords := {}


func _ready() -> void:
	#EventBus.tick.connect(tick_update)
	pass


func _enter_tree():
	child_entered_tree.connect(_register_child)
	child_exiting_tree.connect(_unregister_child)


func _register_child(child):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	scene_coords[coords] = child
	child.set_meta("tile_coords", coords)


func _unregister_child(child):
	scene_coords.erase(child.get_meta("tile_coords"))


func get_cell_scene(coords: Vector2i) -> Node:
	return scene_coords.get(coords, null)


func tick_update() -> void:
	for cell_coords in get_used_cells():
		var cell = get_cell_scene(cell_coords)
		
		if cell and cell.type == Global.TILE_TYPE.BUBBLE:
			check_bubble_collision(cell, cell_coords)



func check_bubble_collision(bubble, bubble_coords):
	var next_position = bubble_coords - Vector2i(0, 1)

	var cell_above_bubble = get_cell_scene(next_position)

	place_tile(next_position, Global.TILE_TYPE.BUBBLE)
	erase_cell(bubble_coords)


func place_tile(location: Vector2i, type: int):
	match type:
		Global.TILE_TYPE.BUBBLE:
			set_cell(location, 0, Vector2i(0, 0), 2)

		_:
			print("INVALID TILE TYPE: ", type)


func remove_tile(location: Vector2i):
	erase_cell(location)
