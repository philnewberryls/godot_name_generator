extends Resource
class_name NameGenerator

const NAME_POOLS_LOCATION: String = "res://name_generator/name_pools/"


func get_available_name_pools() -> Array: 
	assert(DirAccess.open(NAME_POOLS_LOCATION).get_open_error() == OK)
	var name_type_folders = DirAccess.open(NAME_POOLS_LOCATION)
	return name_type_folders.get_directories()


func get_new_name_as_string(name_type: String = "generic_name", is_first_name_requested: bool = true, is_last_name_requested: bool = true) -> String: 
	var available_resources: Array = _get_available_name_pool_resources(name_type)
	
	var new_name: String = ""
	
	# First Name
	if is_first_name_requested and available_resources.has("first_name.tres"): 
		new_name += _get_random_element_from_name_resource(NAME_POOLS_LOCATION + name_type + "/" + "first_name" + ".tres")
	
	if new_name.length() > 0 and is_last_name_requested: new_name += " " # Add a separator if first name has been added
	
	if is_last_name_requested and available_resources.has("last_name.tres"): 
		new_name += _get_random_element_from_name_resource(NAME_POOLS_LOCATION + name_type + "/" + "last_name" + ".tres")
	
	return new_name


func _get_random_element_from_name_resource(name_resource_path) -> String: 
	assert(FileAccess.open(name_resource_path, FileAccess.READ).get_open_error() == OK)
	var name_resource = load(name_resource_path)
	return name_resource.data.pick_random()


func _get_available_name_pool_resources(name_type: String):
	assert(DirAccess.open(NAME_POOLS_LOCATION + "/" + name_type).get_open_error() == OK)
	var name_resource_folder = DirAccess.open(NAME_POOLS_LOCATION + name_type)
	return name_resource_folder.get_files()
