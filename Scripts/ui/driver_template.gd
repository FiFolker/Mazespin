extends PanelContainer

@export var highlight_color : Color

@onready var ranking_label = %RankingLabel
@onready var car_icon = %CarIcon
@onready var driver_name = %DriverName
@onready var chrono = %Chrono
@onready var bg = %Background

var driver : Driver

func _ready():
	Race.ranking_update.connect(_on_update_rank)
	bg.color = Color.TRANSPARENT
	
func load_data(new_driver:Driver) -> void:
	driver = new_driver
	ranking_label.text = str(driver.ranking)
	car_icon.texture = driver.car_data.sprite_small if driver.car_data != null else null
	driver_name.text = driver.short_name()
	chrono.text = Race.chrono_to_string(driver.general_chrono)
	if driver == CurrentDriver.driver:
		bg.color = highlight_color
	
func _process(delta:float):
	
	if Race.state == Race.State.RUNING:
		if driver.ranking != 1:
			var chrono_text : String = Race.chrono_to_string(driver.time_diff)
			if driver.lap_diff > 0:
				var lap_string : String = " lap" if driver.lap_diff == 1 else " laps"
				chrono_text = str(driver.lap_diff) + lap_string
			chrono.text = "+" + chrono_text
		else:
			chrono.text = "Leader"
			
func _on_update_rank()-> void:
	ranking_label.text = str(driver.ranking)
	

