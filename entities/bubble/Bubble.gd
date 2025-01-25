extends Area2D


@onready var world = get_node(Global.world_path)
var type := Global.TILE_TYPE.BUBBLE


func _ready() -> void:
	EventBus.tick.connect(tick_update)


func tick_update():
	var tilemap_position = get_parent().local_to_map(position)

	if $RayCast.is_colliding():
		interact_on_collision($RayCast.get_collider())
		get_parent().remove_tile(tilemap_position)
		return
	
	get_parent().place_tile(tilemap_position + Vector2i.UP, type)
	get_parent().remove_tile(tilemap_position)


func interact_on_collision(collider_object: Node):
	if collider_object.name == "Player":
		world.current_bubbles += Global.BUBBLES_PER_BUBBLE
