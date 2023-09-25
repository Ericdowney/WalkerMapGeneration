@tool
class_name MapVisualizerList extends ItemList

class MapData:
	var map: Map
	var filepath: String
	
	func _init(map: Map, filepath: String):
		self.map = map
		self.filepath = filepath
		

# Properties
# |===================================|
# |===================================|
# |===================================|

var _maps: Array[MapData] = []

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

func add_map(map: Map, filepath: String):
	add_item(map.id)
	_maps.append(MapData.new(map, filepath))

func remove_map_item(index: int):
	_maps.remove_at(index)
	super.remove_item(index)

func get_map_at_index(index: int) -> MapData:
	if _maps.size() > index:
		return _maps[index]
	return null

func _can_drop_data(at_position: Vector2, data):
	if data["files"].size() > 0:
		var resource = ResourceLoader.load(data["files"][0])
		return resource is Map
	return false

func _drop_data(at_position, data):
	if data["files"].size() > 0:
		for filepath in data["files"]:
			var resource = ResourceLoader.load(filepath)
			if resource is Map and _maps.find(resource) == -1:
				add_map(resource, filepath)
