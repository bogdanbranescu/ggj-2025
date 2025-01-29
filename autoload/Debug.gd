extends Node


@onready var world = get_node("../World")
@onready var octopus = get_node("../World/OctopusAI")


func _input(_event: InputEvent) -> void:
	if not Global.IS_DEBUGGING:
		return
	
	if Input.is_action_just_pressed("add_player_hp"):		# =		
		world.heal(10)
	elif Input.is_action_just_pressed("remove_player_hp"):	# -
		world.playerTakeDamage(10)
	
	if Input.is_action_just_pressed("add_octopus_hp"):		# ]
		octopus.handle_take_damage(-10)
	elif Input.is_action_just_pressed("remove_octopus_hp"):	# [
		octopus.handle_take_damage(10)

	if Input.is_action_just_pressed("add_bubbles"):			#2
		world.current_bubbles += 20
	elif Input.is_action_just_pressed("remove_bubbles"):	#1
		world.current_bubbles -= 20
