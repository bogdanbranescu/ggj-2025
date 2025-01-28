extends Control


enum MARKER_TYPE {
    IDLE,
    ATTACK
}

var type := MARKER_TYPE.IDLE


func set_type(marker_type: int):
    for c in get_children():
        c.hide()
            
    match marker_type:
        MARKER_TYPE.IDLE:
            $Idle.show()            
        MARKER_TYPE.ATTACK:
            $Attack.show()
        _:
            print("Incorect timeline marker type: ", type)
