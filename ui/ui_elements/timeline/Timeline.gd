extends Control


@onready var all_markers := $MarkerContainer/Markers
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
			add_marker(1)


func add_marker(type: int):
	var new_marker = marker_scene.instantiate()
	new_marker.set_type(type)
	all_markers.add_child(new_marker)


func cycle_marker(marker: Node, type: int):
	#marker.set_type(randi() % 20)
	marker.get_parent().move_child(marker, -1)


func tick_update() -> void:
	var marker = all_markers.get_children()[0]
	cycle_marker(marker, 0)


func adjust_section():
	pass