extends Control


@onready var marker_container := $MarkerContainer/Markers
@onready var marker_scene := load("res://ui/ui_elements/timeline/Marker.tscn")

var sections := []
var marker_size := 2
var starting_marker_offset := 7


func _ready() -> void:
	EventBus.tick.connect(tick_update)
	
	%Markers.size.x = size.x - 9
	populate_timeline()


func populate_timeline():
	for i in range(%Markers.size.x / 2):
		if i < starting_marker_offset:
			add_marker(0)
		else:
			if randi() % 50 == 0:
				add_marker(1)
			elif randi() % 40 == 0:
				add_marker(2)
			else:
				add_marker(0)


func add_marker(type: int):
	var new_marker = marker_scene.instantiate()
	new_marker.set_type(type)
	marker_container.add_child(new_marker)


func cycle_marker(marker: Node, type: int):
	#marker.set_type(randi() % 20)
	marker.get_parent().move_child(marker, -1)


func tick_update() -> void:
	var all_markers = marker_container.get_children()
	cycle_marker(all_markers[0], 0)

	var marker_count = all_markers.size()

	for i in range(marker_count):
		if i <= all_markers[i].icon_frame_horizon:
			all_markers[i].update_icon(i)
		else:
			all_markers[i].update_icon((marker_count - i) + 1.0)


func adjust_section():
	pass
