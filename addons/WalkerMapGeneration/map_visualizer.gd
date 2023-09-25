@tool
class_name MapVisualizer extends Control

# Properties
# |===================================|
# |===================================|
# |===================================|

@export var room_color: Color

@onready var weight_directions_button: Button = %WeightedDirectionsCheckBox
@onready var regenerate_map_button: Button = %RengerateMapButton
@onready var map_list: MapVisualizerList = %MapList
@onready var grid_container: GridContainer = %GridContainer

var _selected_map_data: MapVisualizerList.MapData :
	get: return _selected_map_data
	set(new_value):
		_selected_map_data = new_value
		regenerate_map_button.visible = _selected_map_data != null

# Lifecycle
# |===================================|
# |===================================|
# |===================================|

func _ready():
	regenerate_map_button.visible = false

# Signals
# |===================================|
# |===================================|
# |===================================|

func _on_map_list_item_selected(index):
	var map_data = map_list.get_map_at_index(index)
	if map_data:
		_visualize_map(map_data)

func _on_new_map_button_pressed():
	var new_map_id = "Map_{num}".format({ "num": map_list._maps.size() + 1 })
	var new_map = MapGenerator.generate_map(new_map_id, 10, 20, RoomFactory.new(), weight_directions_button.button_pressed)
	var new_map_filepath = "res://{name}.tres".format({ "name": new_map_id })
	map_list.add_map(new_map, new_map_filepath)
	
	_visualize_map(MapVisualizerList.MapData.new(new_map, new_map_filepath))
	ResourceSaver.save(new_map, new_map_filepath)

func _on_remove_button_pressed():
	var indices = map_list.get_selected_items()
	if indices.size() > 0:
		for index in indices:
			map_list.remove_map_item(index)
		
		_clear_grid()

func _on_rengerate_map_button_pressed():
	var new_map = MapGenerator.generate_map(_selected_map_data.map.id, _selected_map_data.map.map_area.x, _selected_map_data.map.number_of_steps, _selected_map_data.map.room_factory, weight_directions_button.button_pressed)
	_selected_map_data.map.rooms = new_map.rooms
	_selected_map_data.map.connections = new_map.connections
	
	_visualize_map(_selected_map_data)
	ResourceSaver.save(_selected_map_data.map, _selected_map_data.filepath)

# Methods
# |===================================|
# |===================================|
# |===================================|

func _visualize_map(map_data: MapVisualizerList.MapData):
	_clear_grid()
	_selected_map_data = map_data
	grid_container.columns = map_data.map.map_area.y
	
	for x in range(0, map_data.map.map_area.x):
		for y in range(0, map_data.map.map_area.y):
			var room_location = map_data.map.rooms[x][y]
			var color_rect = ColorRect.new()
			color_rect.custom_minimum_size = Vector2(80, 50)
			if room_location is Room:
				color_rect.color = room_color
			else:
				color_rect.color = Color.from_string("FFFFFF11", Color.TRANSPARENT)
			grid_container.add_child(color_rect)

func _clear_grid():
	for child in grid_container.get_children():
		grid_container.remove_child(child)
