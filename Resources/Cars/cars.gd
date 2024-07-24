extends Resource
class_name Car

enum Category {BERLIN, SPORTIVE, BREAK ,PICKUP, SUV} 
enum Painting {BLACK, BLUE, GREEN, ORANGE, YELLOW}

var name : String : 
	get:
		return get_info()
@export var category : Category
@export var paint : Painting
@export var sprite_small : Texture2D
@export var sprite : Texture2D
@export var speed = 250

func get_category_as_string() -> String:
	return Category.keys()[category].to_pascal_case()

func get_painting_as_string() -> String:
	return Painting.keys()[paint].to_pascal_case()

func get_info() -> String:
	return get_category_as_string() + " " + get_painting_as_string()
	
