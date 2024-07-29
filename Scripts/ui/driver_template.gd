extends PanelContainer

@export var highlight_color : Color

@onready var ranking_label = %RankingLabel
@onready var car_icon = %CarIcon
@onready var driver_name = %DriverName
@onready var chrono = %Chrono
@onready var bg = %Background

var driver : Driver

func _ready():
	Race.ranking_update.connect(update_rank)
	bg.color = Color.TRANSPARENT
	
func load_data(new_driver:Driver) -> void:
	driver = new_driver
	ranking_label.text = str(driver.ranking)
	car_icon.texture = driver.car_data.sprite_small if driver.car_data != null else null
	driver_name.text = driver.driver_name.substr(0, 3).to_upper()
	chrono.text = Race.chrono_to_string(driver.chrono, Race.chrono_precision)
	if driver == CurrentDriver:
		bg.color = highlight_color
	
func _process(delta:float):
	if driver.ranking != 1:
		var difference = 0.0 #to do calculate diff
		chrono.text = Race.chrono_to_string(driver.chrono, Race.chrono_precision)
	else:
		chrono.text = Race.chrono_to_string(driver.chrono, Race.chrono_precision)
func update_rank()-> void:
	ranking_label.text = str(driver.ranking)

