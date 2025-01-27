extends StaticBody2D

@onready var world = get_node(Global.world_path)
var type := Global.TILE_TYPE.COLLECTOR


func interact_on_collision():
	world.current_bubbles += Global.BUBBLES_PER_COLLECTOR
	handle_play_on_shoot()


func handle_play_on_shoot():
	$"AnimatedSprite2D".frame = 1
	await get_tree().create_timer(0.5).timeout
	$"AnimatedSprite2D".frame = 0