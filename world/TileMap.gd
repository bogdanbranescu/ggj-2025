extends TileMapLayer


var scene_coords := {}


func _ready() -> void:
	EventBus.tick.connect(tick_update)


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
		if cell and cell.type == "bubble":
			set_cell(cell_coords - Vector2i(0, 1), 0, Vector2i(0, 0), 2)
			erase_cell(cell_coords)
