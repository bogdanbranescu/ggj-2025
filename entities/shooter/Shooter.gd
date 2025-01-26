extends StaticBody2D

var type := Global.TILE_TYPE.SHOOTER


func interact_on_collision():
    print("Shooter recieved bubble")
    shootAtOctopus()
    pass


func shootAtOctopus():
    print("Shooter shooting at octopus")
    make_bullet()


    pass


func make_bullet():
    var tilemap_position = get_parent().local_to_map(position)
    get_parent().place_tile(tilemap_position + Vector2i.UP, Global.TILE_TYPE.BUBBLE)
