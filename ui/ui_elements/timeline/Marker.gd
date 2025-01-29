extends Control


enum MARKER_TYPE {
	IDLE,
	ATTACK_PLAYER,
	HEAL
}

var type := MARKER_TYPE.IDLE
@onready var icon_frame_horizon: int = 5

func _ready() -> void:
	pass


func set_type(marker_type: int):
	type = marker_type as MARKER_TYPE
	
	for c in get_children():
		c.hide()
			
	match type:
		MARKER_TYPE.IDLE:
			$Idle.show()            
		MARKER_TYPE.ATTACK_PLAYER:
			$Attack.show()
		MARKER_TYPE.HEAL:
			$Heal.show()
		_:
			print("Incorrect timeline marker type: ", type)


func update_icon(position_in_timeline: int) -> void:
	if type == MARKER_TYPE.IDLE:
		return

	var icon = get_children()[type as int].get_node("Icon")

	icon.frame = clampi(icon.hframes - position_in_timeline, 0, icon_frame_horizon - 1)
