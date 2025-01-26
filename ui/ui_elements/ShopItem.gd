extends HBoxContainer


@export_enum("SHOVEL", "HEALTH", "COLLECTOR", "SHOOTER") var type : int
@onready var world = get_node(Global.world_path)

var level := 0
var price: int


func _ready() -> void:
	focus_entered.connect(select)
	focus_exited.connect(deselect)

	price = Global.item_schedules[type].price + level * Global.item_schedules[type].increment
	$Price.text = str(price)


func select() -> void:
	modulate = Color.BLUE


func deselect() -> void:
	modulate = Color.WHITE


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm") and has_focus():
		print(type)
		handle_buy()

	if Input.is_action_just_pressed("cancel") and has_focus():
		print(type)
		%StateChart.send_event("end_shop")


func handle_buy():
	if world.current_bubbles < price:
		return

	world.current_bubbles -= price
	
	match type:
		Global.ITEM_TYPE.HEALTH:
			world.heal(Global.HEAL_AMOUNT)
			%StateChart.send_event("end_shop")

		Global.ITEM_TYPE.SHOVEL:
			print("SHOVEL")
			%Cursor.set_type(Global.ITEM_TYPE.SHOVEL)
			%StateChart.send_event("go_to_placement")

		Global.ITEM_TYPE.COLLECTOR:
			print("COLLECTOR")
			%Cursor.set_type(Global.ITEM_TYPE.COLLECTOR)
			%StateChart.send_event("go_to_placement")

		Global.ITEM_TYPE.SHOOTER:
			print("SHOOTER")
			%Cursor.set_type(Global.ITEM_TYPE.SHOOTER)
			%StateChart.send_event("go_to_placement")

		_:
			print("INVALID SHOP ITEM TYPE: ", type)

	release_focus()
