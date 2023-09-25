class_name Map3DNode extends Node
## This node integrates with the MapGenerator to generate a 2D walker based Map resource.

signal map_generated(node: Map3DNode, map: Map)

var MapGenerator = preload("res://addons/WalkerMapGeneration/map_generator.gd")

# Properties
# |===================================|
# |===================================|
# |===================================|

## The id to use for the newly generated map.
@export var map_id: String = ""

## Map size determines the X by Y width / height of the map. Maps are always square.
@export var map_area: int = 10

## Number of Steps determines how many "steps" the drunken walker takes to create the room layout within the map.
@export var number_of_steps: int = 20

## The room factory creates the room resource. Override to provide additional functionality.
@export var room_factory: RoomFactory = RoomFactory.new()

var map: Map :
	get: return _cached_map

var _cached_map: Map :
	get: return _cached_map
	set(new_value):
		_cached_map = new_value
		_set_map_on_children()

# Lifecycle
# |===================================|
# |===================================|
# |===================================|

func _ready():
	_generate_map()

# Signals
# |===================================|
# |===================================|
# |===================================|



# Methods
# |===================================|
# |===================================|
# |===================================|

func regenerate_map():
	_generate_map()
	
func _generate_map():
	_cached_map = MapGenerator.generate_map(map_id, map_area, number_of_steps, room_factory)
	map_generated.emit(self, _cached_map)

func _set_map_on_children():
	for child in get_children():
		if "map" in child:
			child.map = _cached_map
