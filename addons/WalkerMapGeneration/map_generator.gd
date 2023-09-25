@tool
class_name MapGenerator extends Object
## Generates a Map Resource using the Drunken Walker Algorithm for use when building a Rogue-Like game.
##
## Drunk Walker's Algorithm: Randomly picks a direction for a given step and attempts to walk to the next room in the given direction.
## Possible directions can only ever be North, East, South, and West.

# Properties
# |===================================|
# |===================================|
# |===================================|



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

## Generates a 2D Array of Rooms representing a game map.
static func generate_map(map_id: String, map_area: int, number_of_steps: int, room_factory: RoomFactory, weighted_directions: bool = false) -> Map:
	# Setup the 2-Dimensional array of rooms with default values of zero, signifying no room is present at that square
	var rooms = []
	var connections: Array[Connection] = []
	var last_direction = -1
	var starting_cell = Vector2i(randi_range(4, 7), randi_range(4, 7))
	for x in range(0, map_area):
		rooms.append([])
		for y in range(0, map_area):
			if x == starting_cell.x and y == starting_cell.y:
				var room_id = "Room__{x}_{y}".format({ "x": x, "y": y })
				rooms[x].append(room_factory.create_room(room_id))
			else:
				rooms[x].append(0)
	
	# Drunk Walker's Algorithm: Randomly picks a direction for a given step and attempts to walk to the next room in the given direction.
	# Possible directions can only ever be North, East, South, and West.
	var current_cell = starting_cell
	for index in number_of_steps:
		var direction = randi_range(0, 3)
		if weighted_directions and last_direction >= 0:
			while direction == last_direction:
				direction = randi_range(0, 3)
		
		last_direction = direction
		match direction:
			1: # East
				if current_cell.x + 1 < rooms.size():
					if not rooms[current_cell.x + 1][current_cell.y] is Room:
						var next_room_id = "Room__{x}_{y}".format({ "x": current_cell.x + 1, "y": current_cell.y })
						rooms[current_cell.x + 1][current_cell.y] = room_factory.create_room(next_room_id)
					
					var next_cell = Vector2i(current_cell.x + 1, current_cell.y)
					connections.append(_create_connection(current_cell, next_cell))
					connections.append(_create_connection(next_cell, current_cell))
					current_cell = next_cell
			2: # South
				if current_cell.y + 1 < rooms[current_cell.x].size():
					if not rooms[current_cell.x][current_cell.y + 1] is Room:
						var next_room_id = "Room__{x}_{y}".format({ "x": current_cell.x, "y": current_cell.y + 1 })
						rooms[current_cell.x][current_cell.y + 1] = room_factory.create_room(next_room_id)
					
					var next_cell = Vector2i(current_cell.x, current_cell.y + 1)
					connections.append(_create_connection(current_cell, next_cell))
					connections.append(_create_connection(next_cell, current_cell))
					current_cell = next_cell
			3: # West
				if current_cell.x - 1 >= 0:
					if not rooms[current_cell.x - 1][current_cell.y] is Room:
						var next_room_id = "Room__{x}_{y}".format({ "x": current_cell.x - 1, "y": current_cell.y })
						rooms[current_cell.x - 1][current_cell.y] = room_factory.create_room(next_room_id)
					
					var next_cell = Vector2i(current_cell.x - 1, current_cell.y)
					connections.append(_create_connection(current_cell, next_cell))
					connections.append(_create_connection(next_cell, current_cell))
					current_cell = next_cell
			_: # North
				if current_cell.y - 1 >= 0:
					if not rooms[current_cell.x][current_cell.y - 1] is Room:
						var next_room_id = "Room__{x}_{y}".format({ "x": current_cell.x, "y": current_cell.y - 1 })
						rooms[current_cell.x][current_cell.y - 1] = room_factory.create_room(next_room_id)
					
					var next_cell = Vector2i(current_cell.x, current_cell.y - 1)
					connections.append(_create_connection(current_cell, next_cell))
					connections.append(_create_connection(next_cell, current_cell))
					current_cell = next_cell
	
	var new_map = Map.new()
	new_map.id = map_id
	new_map.rooms = rooms
	new_map.connections = _deduplicate_connections(connections)
	new_map.map_area = Vector2i(map_area, map_area)
	new_map.number_of_steps = number_of_steps
	new_map.room_factory = room_factory
	return new_map

static func _get_backwards_direction(direction: int) -> int:
	match direction:
		1:
			return 3
		2:
			return 0
		3:
			return 1
		_:
			return 2

static func _create_connection(source: Vector2i, destination: Vector2i) -> Connection:
	var new_connection = Connection.new()
	new_connection.source_id = "Room__{x}_{y}".format({ "x": source.x, "y": source.y })
	new_connection.destination_id = "Room__{x}_{y}".format({ "x": destination.x, "y": destination.y })
	return new_connection

static func _deduplicate_connections(connections: Array[Connection]) -> Array[Connection]:
	var unique_connections: Array[Connection] = []
	for connection in connections:
		if not unique_connections.has(connection):
			unique_connections.append(connection)
	
	return unique_connections
