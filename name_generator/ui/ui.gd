extends Control


@export var help_window: PanelContainer

@export var name_type_selection: ItemList

@export var number_of_names: SpinBox

@export var first_characters: LineEdit
@export var leading_characters: LineEdit
@export var trailing_characters: LineEdit
@export var delimiter: LineEdit
@export var final_characters: LineEdit
@export var new_line_check_box: CheckBox

@export var first_name_check_box: CheckBox
@export var last_name_check_box: CheckBox

@export var preview: TextEdit
@export var output: TextEdit


func _on_item_list_ready():
	var name_generator: NameGenerator = NameGenerator.new()
	
	var options: Array = name_generator.get_available_name_pools()
	for option in options: 
		name_type_selection.add_item(option)
	name_type_selection.select(0)


func _on_button_button_up():
	var name_generator: NameGenerator = NameGenerator.new()
	var is_first_name_requested: bool = first_name_check_box.button_pressed
	var is_last_name_requested: bool = last_name_check_box.button_pressed
	var type_of_name_to_generate: String = name_type_selection.get_item_text(name_type_selection.get_selected_items()[0])
	
	var text_to_display: String = ""
	
	text_to_display = first_characters.text
	for name_to_generate in number_of_names.value:
		var generated_name = name_generator.get_new_name_as_string(type_of_name_to_generate, is_first_name_requested, is_last_name_requested)
		text_to_display += _format_name(generated_name)
	if not delimiter.text.is_empty(): text_to_display = text_to_display.left(-delimiter.text.length())
	text_to_display += final_characters.text
	
	output.text = text_to_display



func _format_name(given_name: String) -> String: 
	var formatted_name: String = ""
	if not leading_characters.text.is_empty(): formatted_name += leading_characters.text
	formatted_name += given_name
	if not trailing_characters.text.is_empty(): formatted_name += trailing_characters.text
	formatted_name += delimiter.text
	if new_line_check_box.button_pressed: formatted_name += "\n"
	return formatted_name


func _get_placeholder_name(is_first_name: bool, is_last_name: bool) -> String: 
	var generated_name: String = ""
	if is_first_name: generated_name += "first_name"
	if not generated_name.is_empty(): generated_name += " "
	if is_last_name: generated_name += "last_name"
	return generated_name


func _on_preview_updatable_text_changed(_data = "N/A"):
	_update_preview_text()


func _update_preview_text(): 
	var is_first_name_requested: bool = first_name_check_box.button_pressed
	var is_last_name_requested: bool = last_name_check_box.button_pressed
	
	var text_to_display: String = ""
	
	text_to_display = first_characters.text
	for name_to_generate in 2:
		var generated_name = _get_placeholder_name(is_first_name_requested, is_last_name_requested)
		text_to_display += _format_name(generated_name)
	if not delimiter.text.is_empty(): text_to_display = text_to_display.left(-delimiter.text.length())
	text_to_display += final_characters.text
	
	preview.text = text_to_display
	
	if not new_line_check_box.button_pressed: preview.text += "\n"


func _update_preset(preset_type: String): 
	match preset_type: 
		"gdscript array[string]": 
			first_characters.text = "["
			leading_characters.text = "\""
			trailing_characters.text = "\""
			delimiter.text = ", "
			final_characters.text = "]"
			new_line_check_box.button_pressed = false
		"json array": 
			first_characters.text = "{\n\"names\": ["
			leading_characters.text = "\""
			trailing_characters.text = "\""
			delimiter.text = ", "
			final_characters.text = "]\n}"
			new_line_check_box.button_pressed = false
		_: 
			pass
	_update_preview_text()


func _on_string_preset_button_up():
	_update_preset("gdscript array[string]")


func _on_preview_ready():
	_update_preview_text()


func _on_exit_ready():
	if OS.has_environment("web"): queue_free()


func _on_exit_button_up():
	get_tree().quit()


func _on_close_help_button_up():
	help_window.hide()


func _on_help_button_up():
	help_window.show()


func _on_help_window_exterior_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1: 
			help_window.hide()


func _on_help_window_exterior_ready():
	help_window.hide()


func _on_json_preset_button_up():
	_update_preset("json array")
