extends HBoxContainer


@export_enum("SHOVEL", "HEALTH", "COLLECTOR", "SHOOTER") var type : int

@onready var world = get_node(Global.world_path)
@onready var price_label = $Price as Label
@onready var product_label = $Name as Label

var level := 0
var price: int

var is_affordable := false


func _ready() -> void:
	focus_entered.connect(select)
	focus_exited.connect(deselect)

	EventBus.bubbles_changed.connect(adjust_color)

	price = Global.item_data[type].price + level * Global.item_data[type].increment
	$Price.text = str(price)
	adjust_color(0)


func select() -> void:
	%ShopItemSelectorUI.global_position.y = global_position.y - 4
	%ItemDescription.text = Global.item_data[type].description

	if is_affordable:
		%ShopItemSelectorUI.region_rect.position.x = 0
	else:
		%ShopItemSelectorUI.region_rect.position.x = 20.0


func deselect() -> void:
	pass


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm") and has_focus():
		print(type)
		handle_buy()

	if Input.is_action_just_pressed("cancel") and has_focus():
		release_focus()
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
			%Cursor.set_type(Global.ITEM_TYPE.SHOVEL, price)
			%StateChart.send_event("go_to_placement")

		Global.ITEM_TYPE.COLLECTOR:
			print("COLLECTOR")
			%Cursor.set_type(Global.ITEM_TYPE.COLLECTOR, price)
			%StateChart.send_event("go_to_placement")

		Global.ITEM_TYPE.SHOOTER:
			print("SHOOTER")
			%Cursor.set_type(Global.ITEM_TYPE.SHOOTER, price)
			%StateChart.send_event("go_to_placement")

		_:
			print("INVALID SHOP ITEM TYPE: ", type)

	release_focus()


func adjust_color(bubble_count: int):
	if price <= bubble_count:
		is_affordable = true
		price_label.add_theme_color_override("font_color", Global.COLORS.TEXT_AVAILABLE)
		product_label.add_theme_color_override("font_color", Global.COLORS.TEXT_AVAILABLE)
	else:
		is_affordable = false
		price_label.add_theme_color_override("font_color", Global.COLORS.TEXT_UNAVAILABLE)
		product_label.add_theme_color_override("font_color", Global.COLORS.TEXT_UNAVAILABLE)
