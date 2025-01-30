extends Control


var type := Global.OCTOPUS_ACTION.IDLE
@onready var icon_frame_horizon: int = 5

func _ready() -> void:
	pass


func set_type(marker_type: int):
	type = marker_type as Global.OCTOPUS_ACTION
	
	for c in get_children():
		c.hide()
			
	match type:
		Global.OCTOPUS_ACTION.IDLE:
			$Idle.show()            
		Global.OCTOPUS_ACTION.ATTACK_PLAYER:
			$AttackPlayer.show()
		Global.OCTOPUS_ACTION.HEAL:
			$Heal.show()
		_:
			print("Incorrect timeline marker type: ", type)


func update_icon(position_in_timeline: int) -> void:
	if type == Global.OCTOPUS_ACTION.IDLE:
		return

	var icon = get_children()[type as int].get_node("Icon")		# WARNING this is dependent on order of Global.OCTOPUS_ACTION items!

	icon.frame = clampi(icon.hframes - position_in_timeline, 0, icon_frame_horizon - 1)
