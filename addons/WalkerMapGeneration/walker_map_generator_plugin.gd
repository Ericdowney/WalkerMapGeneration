@tool
extends EditorPlugin

var MapVisualizer = preload("res://addons/WalkerMapGeneration/map_visualizer.tscn")

# Properties
# |===================================|
# |===================================|
# |===================================|

var _map_dock

# Lifecycle
# |===================================|
# |===================================|
# |===================================|

func _enter_tree():
	_map_dock = MapVisualizer.instantiate()
	add_control_to_bottom_panel(_map_dock, "Map")

func _exit_tree():
	_remove_map_dock()

# Signals
# |===================================|
# |===================================|
# |===================================|



# Methods
# |===================================|
# |===================================|
# |===================================|

func _remove_map_dock():
	if _map_dock:
		remove_control_from_bottom_panel(_map_dock)
		_map_dock = null
