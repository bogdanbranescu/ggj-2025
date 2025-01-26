extends StaticBody2D

@onready var world = get_node(Global.world_path)
var type := Global.TILE_TYPE.COLLECTOR


func interact_on_collision():
	world.current_bubbles += Global.BUBBLES_PER_COLLECTOR
	var tilemap_position = get_parent().local_to_map(position)
	get_parent().remove_tile(tilemap_position)
	pass ;
