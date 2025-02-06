extends Control


@onready var marker_container := $MarkerContainer/Markers
@onready var marker_scene := load("res://ui/ui_elements/timeline/Marker.tscn")

var marker_size := 2
var starting_marker_offset := 7


func _ready() -> void:
	EventBus.tick.connect(tick_update)
	
	%Markers.size.x = size.x - 9
	populate_timeline()
		

func populate_timeline():
	for i in range(%Markers.size.x / 2):
		if i < starting_marker_offset: # due to indicator sprite's offset in the gauge
			add_marker({type = Global.OCTOPUS_ACTION.IDLE, data = {}})
		else:
			add_marker(%Timekeeper.upcoming_actions[i - starting_marker_offset])


func add_marker(marker_data: Dictionary):
	var new_marker = marker_scene.instantiate()
	new_marker.set_data(marker_data)
	marker_container.add_child(new_marker)


func cycle_marker(marker: Node, marker_data: Dictionary):
	marker.set_data(marker_data)
	marker.get_parent().move_child(marker, -1)


func tick_update() -> void:
	var all_markers = marker_container.get_children()
	var data_after_cycle = %Timekeeper.upcoming_actions[%Markers.size.x / 2 - starting_marker_offset]
	cycle_marker(all_markers[0], data_after_cycle)

	var marker_count = all_markers.size()

	for i in range(marker_count):
		if i <= all_markers[i].icon_frame_horizon:
			all_markers[i].update_icon(i)
		else:
			all_markers[i].update_icon((marker_count - i) + 1.0)
