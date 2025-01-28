extends StaticBody2D

var type := Global.TILE_TYPE.SHOOTER


func interact_on_collision():
	print("Shooter recieved bubble")
	shootAtOctopus()
	pass

func shootAtOctopus():
	make_bullet()
	handle_play_on_shoot()
	$SFX.play()


func make_bullet():
	var tilemap_position = get_parent().local_to_map(position)
	get_parent().place_tile(tilemap_position + Vector2i.UP, Global.TILE_TYPE.BULLET)

func handle_play_on_shoot():
	$"AnimatedSprite2D".frame = 1
	await get_tree().create_timer(0.5).timeout
	$"AnimatedSprite2D".frame = 0