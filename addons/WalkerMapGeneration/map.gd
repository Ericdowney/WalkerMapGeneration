@tool
class_name Map extends Resource
## Map represents the data for a 2 dimensional layout in a graph structure.
##
## The 2D rooms array is filled in with zeroes before rooms are generated.
## Any loops over rooms should first check to determine if the array location is a Room resource.

# Properties
# |===================================|
# |===================================|
# |===================================|

@export var id: String
@export var rooms: Array
@export var connections: Array[Connection]
@export var map_area: Vector2i
@export var number_of_steps: int
@export var room_factory: RoomFactory

## This is the size based on the available rooms. This will always be smaller than the map_area
var map_size: Vector2i :
	get:
		if _map_size == Vector2i(-1, -1):
			_calculate_map_size()
		return _map_size

var _map_size: Vector2i = Vector2i(-1, -1)

# Lifecycle
# |===================================|
# |===================================|
# |===================================|



# Signals
# |===================================|
# |===================================|
# |===================================|



# Methods
# |===================================|
# |===================================|
# |===================================|

func regenerate_map_size():
	_calculate_map_size()

func _calculate_map_size():
	var min_x = INF
	var min_y = INF
	var max_x = -1
	var max_y = -1
	for x_index in rooms.size():
		for y_index in rooms[x_index].size():
			if rooms[x_index][y_index] is Room:
				min_x = mini(min_x, x_index)
				min_y = mini(min_y, y_index)
				
				max_x = maxi(max_x, x_index)
				max_y = maxi(max_y, y_index)
	
	_map_size = Vector2i(max_x - min_x, max_y - min_y)
