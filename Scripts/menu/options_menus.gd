extends CanvasLayer

@onready var input_choice = %InputChoice
@onready var language = %Language

# Called when the node enters the scene tree for the first time.
func _ready():
	if OptionsValues.input == OptionsValues.INPUT.CONTROLLER:
		input_choice.grab_focus()
	
	init_input()
	init_translation()

func init_input() -> void:
	var selected_index = -1
	var index = 0
	
	for input in OptionsValues.INPUT:
		index = input_choice.item_count
		input_choice.add_item(input)
		if OptionsValues.input == OptionsValues.INPUT[input]:
			selected_index = index
	input_choice.select(selected_index)

func init_translation() -> void:
	var index = -1
	var loaded_locales : PackedStringArray = TranslationServer.get_loaded_locales()
	for locale in loaded_locales:
		index += 1
		
		var language_name : String = TranslationServer.get_language_name(locale)
		language.add_item(language_name)
		language.set_item_tooltip(index, locale)
		
		if TranslationServer.get_locale().contains(language.get_item_tooltip(index)):
			language.select(index)
			

func _on_menu_btn_button_down():
	SceneManager.goto_scene_menu("menu")


func _on_input_choice_item_selected(index):
	OptionsValues.input = OptionsValues.INPUT[input_choice.get_item_text(index)]


func _on_language_item_selected(index):
	var language_name = language.get_item_tooltip(index)
	TranslationServer.set_locale(language_name)
