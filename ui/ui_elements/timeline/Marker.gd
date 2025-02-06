extends Control


@onready var icon_frame_horizon: int = 5

var type := Global.OCTOPUS_ACTION.IDLE


func _ready() -> void:
	pass


func set_data(marker_data: Dictionary):
	type = marker_data.type as Global.OCTOPUS_ACTION

	if type != Global.OCTOPUS_ACTION.IDLE:
		print(marker_data)
		var amount_label = get_children()[type as int].get_node("Amount")
		amount_label.text = str(marker_data.data.amount)
		
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

	var icon = get_children()[type as int].get_node("Icon") # WARNING this is dependent on order of Global.OCTOPUS_ACTION items!
	icon.frame = clampi(icon.hframes - position_in_timeline, 0, icon_frame_horizon - 1)

	var amount_label = get_children()[type as int].get_node("Amount")
	amount_label.visible = icon.frame == 0
