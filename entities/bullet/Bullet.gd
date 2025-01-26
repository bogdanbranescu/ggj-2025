extends Area2D


var type := Global.TILE_TYPE.BULLET

func _ready() -> void:
	EventBus.tick.connect(tick_update)


func tick_update():
	if $RayCast.is_colliding():
		interact_on_collision($RayCast.get_collider())
		return
	bullet_up()


func interact_on_collision(collider_object: Node):
	var tilemap_position: Vector2i = get_parent().local_to_map(position)

	var tileLayer: TileMapLayer = get_parent()
	var tile_source_id = tileLayer.get_cell_source_id(tilemap_position + Vector2i.UP)

	var outOfBoundsTileId = 1; # Had to debug it to figure that out

	if (tile_source_id == outOfBoundsTileId):
		EventBus.octopus_take_damage.emit()


	get_parent().remove_tile(tilemap_position)

func bullet_up():
	var tilemap_position = get_parent().local_to_map(position)
	get_parent().place_tile(tilemap_position + Vector2i.UP, type)
	get_parent().remove_tile(tilemap_position)
