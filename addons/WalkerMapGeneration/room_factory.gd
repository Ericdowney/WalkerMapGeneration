@tool
class_name RoomFactory extends Resource
## The RoomFactory is used by the MapGenerator to create the room resources that fill in the map.
##
## This node should be overriden along with the Room resource to provide additional data for each room in the game world.

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

## Given the generated id for a room, create a new Room resource that will be used to fill in the Map resource.
func create_room(id: String) -> Room:
	var new_room = Room.new()
	new_room.id = id
	return new_room
