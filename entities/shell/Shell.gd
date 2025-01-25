extends StaticBody2D


var type := Global.TILE_TYPE.URCHIN

var bubble_interval_counter := 0


func _ready() -> void:
	EventBus.tick.connect(tick_update)


func tick_update() -> void:
	bubble_interval_counter += 1
	if bubble_interval_counter >= Global.SHELL_INTERVAL:
		bubble_interval_counter = 0
		
		make_bubble()


func make_bubble():
	var tilemap_position = get_parent().local_to_map(position)
	get_parent().place_tile(tilemap_position + Vector2i.UP, Global.TILE_TYPE.BUBBLE)
