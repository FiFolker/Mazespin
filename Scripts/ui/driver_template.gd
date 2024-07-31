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
	if driver == CurrentDriver:
		bg.color = highlight_color
	
func _process(delta:float):
	
	if Race.state == Race.State.RUNING:
		if driver.ranking != 1:
			
			var difference = (Race.leaderboard[0].car.progress_ratio - (driver.car.progress_ratio + (driver.current_lap - Race.leaderboard[0].current_lap ))) * Race.leaderboard[0].general_chrono
			chrono.text = "+" + Race.chrono_to_string(difference)
		else:
			chrono.text = "Leader"
			
func _on_update_rank()-> void:
	ranking_label.text = str(driver.ranking)
	

